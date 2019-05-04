#!/bin/bash

if [ -f /vagrant/certs/chef-configured ]; then
  echo "chef server already configured!"
  exit 0
fi

DEBIAN_FRONTEND=noninteractive apt-get -y install curl

# create staging directories
if [ ! -d /vagrant/certs ]; then
  mkdir /vagrant/certs
fi
if [ ! -d /vagrant/downloads ]; then
  mkdir /vagrant/downloads
fi

# download the Chef server package
if [ ! -f /vagrant/downloads/chef-server-core_12.19.31-1_amd64.deb ]; then
  echo "Downloading the Chef server package..."
  wget -nv -P /vagrant/downloads https://packages.chef.io/files/stable/chef-server/12.19.31/ubuntu/16.04/chef-server-core_12.19.31-1_amd64.deb
fi

# install Chef server
if [ ! $(which chef-server-ctl) ]; then
  echo "Installing Chef server..."
  dpkg -i /vagrant/downloads/chef-server-core_12.19.31-1_amd64.deb
  chef-server-ctl reconfigure

  echo "Waiting for services..."
  until (curl -D - http://localhost:8000/_status) | grep "200 OK"; do sleep 15s; done
  while (curl http://localhost:8000/_status) | grep "fail"; do sleep 15s; done

  echo "Creating initial user ..."
  chef-server-ctl user-create chefadmin Chef Admin admin@example.com chefadmin --filename /vagrant/certs/chefadmin.pem
fi

chef-server-ctl install chef-manage
chef-server-ctl reconfigure
chef-manage-ctl reconfigure --accept-license

touch /vagrant/certs/chef-configured

printf "\033c"
echo "Chef Console is ready: http://chef-server/ with login: chefadmin password: chefadmin"
