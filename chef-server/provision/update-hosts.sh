#!/bin/bash

# remove all entries after vagrant comment
sed -n '/# vagrant environment nodes/q;p' /etc/hosts > /tmp/hosts
cat /tmp/hosts > /etc/hosts && rm /tmp/hosts

# configure hosts file for our internal network defined by Vagrantfile
cat >> /etc/hosts <<EOL
# vagrant environment nodes
10.0.15.10  chef-server
10.0.15.100  node-ubuntu
10.0.15.101  node-centos
10.0.15.102  node-debian
EOL
