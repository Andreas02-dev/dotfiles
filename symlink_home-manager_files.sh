#!/bin/sh

config_dir=`pwd`
home_dir=/home/$USER
cd $home_dir/.config/home-manager
sudo cp -rs $config_dir/home-manager $home_dir/.config
