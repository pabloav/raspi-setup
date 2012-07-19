#!/bin/sh

# To bootstrap
# wget --no-check-certificate -Oraspi-setup.tgz https://github.com/pabloav/raspi-setup/tarball/master

chmod a+x setup.d/*
run-parts setup.d
