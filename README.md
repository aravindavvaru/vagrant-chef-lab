# Local Chef test environment

This is my local [Chef](https://www.chef.io) test environment, that I run locally on my MacBook. It consists of the chef-server, the nodes to be managed and the chef-client tools.

## Requirements

- Virtual Box
- Vagrant + vagrant-hostsupdater Plugin
- Chef-Workstation (https://downloads.chef.io/chef-workstation/)

### Setup instructions

I personally use Homebrew (https://brew.sh) to install Virtual Box, Virtual Box Extension Pack and Vagrant and keep them up to date. If you don't use it yet, check it out. I install most of my software packages with it.

````
# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Virtual Box + Extension Pack
brew cask install virtualbox
brew cask install virtualbox-extension-pack

# Vagrant
brew cask install vagrant

# Install Vagrant Hosts Update Plugin
vagrant plugin install vagrant-hostsupdater

# Allow the plugin to automatically update /etc/hosts when a machine is brought up or down

# Edit the sudoers configuration by adding the vagrant_hostsupdater file
sudo visudo -f /etc/sudoers.d/vagrant_hostsupdater

# put the following in the file /etc/sudoers.d/vagrant_hostsupdater:

# Allow passwordless startup of Vagrant with vagrant-hostsupdater.
Cmnd_Alias VAGRANT_HOSTS_ADD = /bin/sh -c echo "*" >> /etc/hosts
Cmnd_Alias VAGRANT_HOSTS_REMOVE = /usr/bin/sed -i -e /*/ d /etc/hosts
%admin ALL=(root) NOPASSWD: VAGRANT_HOSTS_ADD, VAGRANT_HOSTS_REMOVE

# If using Windows, then you can give your user modify rights to the hosts file
# Execute in Admin-CMD: icacls %SYSTEMROOT%\system32\drivers\etc\hosts /GRANT %USERNAME%:(M)
````

Now install the Chef-Workstation Tools that you previously downloaded.


## Bring up the Chef-Server

Change to chef-server directory and run

```
vagrant up
```

This will download the vagrant box, install the chef-server package and update the hosts file to point 10.0.15.10 to the name "chef-server".

Afterwards, you can go to (https://chef-server) to create an internal organization to manage the test nodes. 

- User: chefadmin
- Password: chefadmin

Now you can download the Starter kit from the chef-server, extract it and change into the created directory *chef-repo*.

Test the setup by connecting to the local chef server:

```
# fetch ssl certificate to the trust store, because it is self signed and can't be validated
knife ssl fetch

# check connection
knife ssl check

# test upload the example cookbooks / role
knife cookbook upload starter

# delete uploaded cookbook
knife cookbook delete starter
```

## Bring up nodes to manage

The included node configurations will start with the minimal bento Images and prepared /etc/hosts file. The IPs and names are the following:

- node-ubuntu - 10.0.15.100
- node-centos - 10.0.15.101
- node-debian - 10.0.15.102
