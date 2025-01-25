#!/usr/bin/bash

#clear screen
clear

#welcome massage
echo -e "\nManeging data base:\n"

#menu
while true; do
    echo "Type a number"
    read  -rp "Main Menue.
    1- Creat Table
    2- Insert int table 
    3- select from table
    4- Delete from table
    5- Update table
    6- Back to main menu " -n1 usr_choice

    # if user input is not a number
    if [[ ! $usr_choice = [0-9] ]]; then
        echo -e "\n${red}Wrong Input: Please type a number.${white}"
        sleep 1
        break
    fi

    case $usr_choice in 
        1)
            source ../createtable.sh
        ;;
        2)
            source ../insert.sh
        ;;
        3)
            source ../selecttable.sh
        ;;
        4)
            source ../deletetable.sh
        
        ;;
        5)
            source ../updateDB.sh
        
        ;;
        6)
        break
        return

        ;;
        *)
        echo -e "\n${red}Invalid Input: Please Choose again.${white}"
        sleep 1
    esac
done