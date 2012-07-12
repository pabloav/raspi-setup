#!/bin/sh

# To bootstrap
# wget --no-check-certificate https://github.com/pabloav/raspi-setup/tarball/master

chmod a+x setup.d/*
run-parts setup.d
