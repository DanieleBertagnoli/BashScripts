#!/bin/bash

usage="Usage: passwordManager [-r][-a][-l]"

list=0
add=0
remove=0

while getopts "lar" arg; do #Getting the options

    case $arg in        
        l) #List all the accounts
            list=1
            ;;
        
        a) #Add new account
            add=1
            ;;

        r) #Remove an account
            remove=1
            ;;

        *) #Show the usage
            echo $usage
            exit 1
            ;;
    esac

done

if [ $# -eq 0 ] ; then #No options
    
    echo $usage
    exit 1

fi

if [ $list -eq 1 ] ; then #List all accounts
    
    cat accounts.txt | awk '{print NR ")" $1}'

    row=""
     while [ ${#row} -eq 0 ] ; do

        echo "Please enter the row"
        read row

        if ! [[ $row =~ ^[0-9]+$ ]] ; then #If the row is not an integer, then loop again
            row=""
        fi

        lines=0
        lines=$(wc -l accounts.txt | awk '{print $1}')
        if [ $row -gt $lines ] ; then #If the row is too big, then loop again
            echo "Row number too big"
            row=""
        fi
        if [ $row -lt 1 ] ; then #If the row is too small, then loop again
            echo "Row number too small"
            row=""
        fi

    done

    site=$(head --lines=$row accounts.txt | tail --lines=1 | awk '{print $1}') #Get site name
    username=$(head --lines=$row accounts.txt | tail --lines=1 | awk '{print $2}') #Get username
    password=$(head --lines=$row accounts.txt | tail --lines=1 | awk '{print $3}') #Get password

    echo -e "\n\nSite: $site"
    echo "Username: $username"
    echo "Password: $password"

    exit 0
fi

if [ $add -eq 1 ] ; then #Add new account 
    
    site=""
    username=""
    password=""

    while [ ${#site} -eq 0 ] ; do
        echo "Please enter the name of the account (NO SPACE ALLOWED): " #Get the site name
        read site
    done
    
    while [ ${#username} -eq 0 ] ; do
        echo "Please enter the email/username: " #Get the username
        read username
    done
    
    while [ ${#password} -eq 0 ] ; do
        echo "Please enter the password: " #Get the password
        read password
    done  

    echo $site $username $password >>accounts.txt #Append the infos into the file

    exit 0

fi

if [ $remove -eq 1 ] ; then #Remove an existing account
    
    cat accounts.txt | awk '{print NR ")" $0}'

    row=""

    while [ ${#row} -eq 0 ] ; do

        echo "Please enter the row"
        read row

        if ! [[ $row =~ ^[0-9]+$ ]] ; then #If the row is not an integer, then loop again
            row=""
        fi

        lines=0
        lines=$(wc -l accounts.txt | awk '{print $1}')
        if [ $row -gt $lines ] ; then #If the row is too big, then loop again
            echo "Row number too big"
            row=""
        fi
        if [ $row -lt 1 ] ; then #If the row is too small, then loop again
            echo "Row number too small"
            row=""
        fi

    done

    confirm=""
    while [[ $confirm != "y" ]] && [[ $confirm != "n" ]] ; do #Ask for confirm

        echo "Are you sure? y/n"
        read confirm

    done

    if [ $confirm == "n" ] ; then #If no, then exit
        echo "Aborting"
        exit 0
    fi

    sed -i $row'd' ./accounts.txt #Delete the selected row

    echo "Row $row deleted successfully"

    exit 0
fi

