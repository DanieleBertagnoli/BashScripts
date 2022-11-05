#!/bin/bash

#TODO se l'utente mette una directory che non esiste chiedere se si vuole creare

directory=$1; #Take the name of the directory that must be updated
error=0;
piTailscaleIP="pi@100.82.7.120";
piSSHPort="700";

#Directory path raspberry

universityPi="Documents/University";

#Directory local path

universityLocal="Documents/University";

case $directory in #Check if the given directory is known or not

    University)
        echo "University directory selected";
        directory=$universityLocal;
        directoryPi=$universityPi;
        ;;
    
    *)
        echo "No directory";
        error=1;
        ;;
esac;

if [ $error -eq 0 ]; then #If the directory is valid then update it

    echo "Turning on tailscale";
    sudo tailscale up;

    echo "Updating files...";
    rsync -avzu -e "ssh -p $piSSHPort" $piTailscaleIP:~/$directoryPi/* ~/$directory; #Get new files form raspberry
    rsync -avzu -e "ssh -p $piSSHPort" ~/$directory/* $piTailscaleIP:~/$directoryPi; #Send new files to raspberry
    echo "Files are up to date";

fi;