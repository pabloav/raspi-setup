#!/bin/sh

echo "Fix /etc/apt/sources.list"
update-rc.d ssh defaults
update-rc.d portmap disable
update-rc.d nfs-common disable
adduser pablo


apt-get update
apt-get install ruby1.9.1 python-imaging git-core

dpkg-reconfigure tzdata