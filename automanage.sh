#/bin/bash

#Description: Script that execute automatically apt-get update, upgrade, autoclean and autoremove

sudo apt-get update;
sudo apt-get upgrade -y;
sudo apt-get autoclean -y;
sudo apt-get autoremove -y;