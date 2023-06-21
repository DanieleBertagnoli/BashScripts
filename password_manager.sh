#!/bin/bash

#Description: Script that implemets a CLI password manager. In the ./psswdmng directory you can find the config file, it contains all the GPG mail that are authorized
# to encrypt and decrypt the file.

if ! [ -f "./psswdmng/config" ] ; then #Create files

    mkdir psswdmng #Create directory
    touch ./psswdmng/config #Create config file
    echo "Insert your mail (use the GPG mail)"
    read mail
    echo $mail > ./psswdmng/config

fi

usage="Usage: passwordManager [-r to delete an account][-a to add a new account][-l to list the account][-e to add a new GPG mail]"

list=0
add=0
remove=0
mail=0

while getopts "lare" arg; do #Getting the options

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
        
        e) #Add new GPG mail
            mail=1
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
    
    if [ -f "accounts.tmp.gpg" ] ; then #Check if file exists, if not then do not decrypt
        gpg --quiet --output accounts.tmp -d accounts.tmp.gpg 
    else
        echo "No accounts detected"
        exit 0
    fi

    cat accounts.tmp | awk '{print NR ")" $1}'

    row=""
     while [ ${#row} -eq 0 ] ; do

        echo "Please enter the row (0 to exit)"
        read row

        if ! [[ $row =~ ^[0-9]+$ ]] ; then #If the row is not an integer, then loop again
            row=""
        fi

        lines=0
        lines=$(wc -l accounts.tmp | awk '{print $1}')
        if [ $row -gt $lines ] ; then #If the row is too big, then loop again
            echo "Row number too big"
            row=""
        fi
        if [ $row -eq 0 ] ; then #If the row is 0, then abort
            echo "Goodbye!"
            rm accounts.tmp #Delete plain text file
            exit 0
        fi

        site=$(head --lines=$row accounts.tmp | tail --lines=1 | awk '{print $1}') #Get site name
        username=$(head --lines=$row accounts.tmp | tail --lines=1 | awk '{print $2}') #Get username
        password=$(head --lines=$row accounts.tmp | tail --lines=1 | awk '{print $3}') #Get password

        echo -e "\n\nSite: $site"
        echo "Username: $username"
        echo "Password: $password"
        row=""

    done

    rm accounts.tmp #Delete plain text file

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

    if [ -f "accounts.tmp.gpg" ] ; then #Check if file exists, if not then do not decrypt
        gpg --quiet --output accounts.tmp -d accounts.tmp.gpg
    fi

    echo $site $username $password >>accounts.tmp #Append the infos into the file

    rm accounts.tmp.gpg 2>/dev/null #Delete old crypted file
    dest=$(cat ./psswdmng/config) #Get destination mail
    gpg -r $dest -e accounts.tmp #Encrypt file
    rm accounts.tmp #Delete plain text file

    exit 0

fi

if [ $remove -eq 1 ] ; then #Remove an existing account
    
    if [ -f "accounts.tmp.gpg" ] ; then #Check if file exists, if not then do not decrypt
        gpg --quiet --output accounts.tmp -d accounts.tmp.gpg
    else
        echo "No accounts detected"
        exit 0
    fi

    cat accounts.tmp | awk '{print NR ")" $0}'

    row=""

    while [ ${#row} -eq 0 ] ; do

        echo "Please enter the row"
        read row

        if ! [[ $row =~ ^[0-9]+$ ]] ; then #If the row is not an integer, then loop again
            row=""
        fi

        lines=0
        lines=$(wc -l accounts.tmp | awk '{print $1}')
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

    sed -i $row'd' ./accounts.tmp #Delete the selected row

    rm accounts.tmp.gpg 2>/dev/null #Delete old crypted file
    dest=$(cat ./psswdmng/config) #Get destination mail
    gpg -r $dest -e accounts.tmp #Encrypt file
    rm accounts.tmp #Delete plain text file

    echo "Row $row deleted successfully"

    exit 0
fi

if [ $mail -eq 1 ] ; then

    echo "Please insert the new GPG mail, leave blank to abort"
    read newMail

    if [ ${#newMail} -eq 0 ] ; then #Is blank
        echo "Aborted"
        exit 0
    fi 

    oldConfig=$(cat ./psswdmng/config) #Get old mails
    newConfig=$(echo $oldConfig $newMail) #Add new mail
    echo $newConfig > ./psswdmng/config #Update config file
    echo "New mail added"

    exit 0

fi