#!/bin/sh

# Change ownership to current user
sudo chown $USER ./keys/*

# Private keys should be 600 (-rw-------)
sudo chmod 600 ./keys/*

# Public keys should be 644 (-rw-r--r--)
sudo chmod 644 ./keys/*.pub

# Move files to `.ssh` directory
sudo mv ./keys/* /home/$USER/.ssh/
