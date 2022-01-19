#/bin/bash

#Descrizione: Script che effettua automaticamente update, upgrade, autoclean e autoremove dei pacchetti installati

sudo apt-get update;
sudo apt-get upgrade -y;
sudo apt-get autoclean -y;
sudo apt-get autoremove -y;