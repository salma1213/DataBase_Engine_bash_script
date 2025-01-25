#!/usr/bin/bash

#clear screen
clear

#Data Base name
echo -e "\nDeleting data base:"
read -rp "Enter your DB name: " db_name


# Replace spaces with underscores
db_name=$(echo "$db_name" | tr ' ' '_')

# Get list of directories (databases)
files=$(ls -F | grep  / )


# Check if files is empty (no databases exist)
if [[ -z "$files" ]]; then
    echo -e "\n${red}Error: No databases found.${white}"
    return
fi

# Check if the directory DB exists
if [[ -d "$db_name" ]]; then
    rm -r "$db_name"
    echo "Removing $db_name ...."
    sleep 1
    echo "$db_name data base has been removed successfully."
else
    echo -e "${red}Error: $db_name No such Data Base found.${white}"
fi

