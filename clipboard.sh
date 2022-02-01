#!/bin/bash

#Description: Script that create a file in the directory ~/Scrivania named clipboard.txt, in this file you can find the current clipboard history

trap "exit" INT

cd
cd Scrivania

while [ 1 -gt 0 ] 
do

    sleep 2
    if [[ "$clipboardText" != "$(xsel -b)" ]] 
    then
        echo "$(xsel -b)" >>"clipboard.txt"
    fi
    clipboardText="$(xsel -b)"

done