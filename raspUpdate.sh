#!/bin/bash

#TODO se l'utente mette una directory che non esiste chiedere se si vuole creare

directory=$1; #Take the name of the directory that must be updated
error=0;
piTailscaleIP="pi@100.82.7.120";
piSSHPort="700";

#Directory path raspberry

universityPi="Documents/University";
computerSciencePi="Documents/University/ComputerScience";
computerScience2Local="Documents/University/ComputerScience/FY/SS";

#Directory local path

universityLocal="Documents/University";
computerScienceLocal="Documents/University/ComputerScience"
computerScience2Local="Documents/University/ComputerScience/FY/SS";

case $directory in #Check if the given directory is known or not

    University)
        echo "University directory selected";
        directory=$universityLocal;
        directoryPi=$universityPi;
        ;;
    
    CS)
        echo "ComputerScience directory selected"
        directory=$computerScienceLocal;
        directoryPi=$computerSciencePi
        ;;
    
    CS2)
        echo "ComputerScience directory selected"
        directory=$computerScienceLocal;
        directoryPi=$computerSciencePi
        ;;

    *)
        echo "No directory";
        error=1;
        ;;
esac;

if [ $error -eq 0 ]; then #If the directory is valid then update it

    echo "Turning on tailscale";
    sudo tailscale up;

    echo "Directory are:"; 
    echo "$directoryPi in RaspberryPi";
    echo "$directory in Local"
    echo "Continue? [y/n]"
    read response;
    
    if [ $response == "y" ]; then #If the directories are right then continue
    
        rsync -avzu -e "ssh -p $piSSHPort" $piTailscaleIP:~/$directoryPi/* ~/$directory; #Get new files form raspberry
        rsync -avzu -e "ssh -p $piSSHPort" ~/$directory/* $piTailscaleIP:~/$directoryPi; #Send new files to raspberry
        echo "Files are up to date";
    
    fi;

fi;
