#!/bin/sh

# To bootstrap
# wget --no-check-certificate -Oraspi-setup.tgz https://github.com/pabloav/raspi-setup/tarball/master


VERSION=squeeze
if grep wheezy /etc/debian_version > /dev/null; then
  VERSION=raspbian
fi
export VERSION

chmod a+x setup.d/*
run-parts setup.d
