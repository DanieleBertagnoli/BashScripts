#!/bin/bash

#Descrizione: Script che crea un file sulla directory ~/Scrivania chiamato clipboard.txt, all'interno del quale viene salvata la clipboard corrente

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