#!/bin/sh

# To bootstrap
# wget --no-check-certificate -Oraspi-setup.tgz https://github.com/pabloav/raspi-setup/tarball/master


if [ "$UID" -ne "0" ]; then
  echo "Please run this as root."
  exit 1
fi

VERSION=squeeze
if grep wheezy /etc/debian_version > /dev/null; then
  VERSION=raspbian
fi
export VERSION

chmod a+x setup.d/*
run-parts setup.d
