#!/usr/bin/bash

#clear screen
clear

echo -e "\nConnecting to data base:\n"


# Check if any databases exist
if [[ -z "$(ls -F | grep  / )"  ]]; then
    echo -e "${red}Error: No databases found.\n${white}"
    return
fi 

#Getting Data base name
read -rp "Enter your DB name: " db_name

# Replace spaces with underscores
db_name=$(echo "$db_name" | tr ' ' '_')

# Check if DB exists
if [[ -d "$db_name" ]]; then
    echo -e "\nConnecting to $db_name..."
    sleep 1
    cd "./$db_name"
    echo -e "The current workong directory is \n$PWD"
    source ../mangeDB.sh
    cd ../
    echo "The current workong directory is $PWD"
    return

    #Data base name doesn't exit
else
    echo -e "\n${red}Error: $db_name Data Base doesn't exist.${white}"
    return
fi
