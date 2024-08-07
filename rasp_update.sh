#!/bin/bash

#TODO se l'utente mette una directory che non esiste chiedere se si vuole creare

directory=$1; #Take the name of the directory that must be updated
error=0;
piTailscaleIP="pi@100.82.7.120";
piSSHPort="700";

#Directory path raspberry

universityPi="Documents/University";
computerSciencePi="Documents/University/ComputerScience";
computerScience1Pi="Documents/University/ComputerScience/FY/";
computerScience2Pi="Documents/University/ComputerScience/SY/SS";
thesisPi="Documents/University/ComputerScience/Thesis";
personalKnowledgePi="Documents/PersonalProjects/PersonalKnowledge"

#Directory local path

universityLocal="Documents/University";
computerScienceLocal="Documents/University/ComputerScience"
computerScience1Local="Documents/University/ComputerScience/FY/";
computerScience2Local="Documents/University/ComputerScience/SY/SS";
thesisLocal="Documents/University/ComputerScience/Thesis";
personalKnowledgeLocal="Documents/PersonalProjects/PersonalKnowledge"

case $directory in #Check if the given directory is known or not

    U)
        echo "University directory selected";
        directory=$universityLocal;
        directoryPi=$universityPi;
        ;;
    
    CS)
        echo "ComputerScience directory selected"
        directory=$computerScienceLocal;
        directoryPi=$computerSciencePi
        ;;
    
    CS1)
        echo "ComputerScience directory selected"
        directory=$computerScience1Local;
        directoryPi=$computerScience1Pi
        ;;

    CS2)
        echo "ComputerScience directory selected"
        directory=$computerScience2Local;
        directoryPi=$computerScience2Pi
        ;;

    T)
        echo "Thesis directory selected"
        directory=$thesisLocal;
        directoryPi=$thesisPi
        ;;

    PK)
        echo "PersonalKnowledge directory selected"
        directory=$personalKnowledgeLocal;
        directoryPi=$personalKnowledgePi
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
