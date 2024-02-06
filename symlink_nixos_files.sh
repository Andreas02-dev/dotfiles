#!/bin/sh

config_dir=`pwd`
cd /etc/nixos
sudo cp -rs "$config_dir/etc/nixos" /etc
