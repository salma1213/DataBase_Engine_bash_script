#!/usr/bin/bash

#clear screen
clear

#Data Base name
echo -e "\nCreating data base:
the name should be uniqe 
starts with a letter and doesn't include spacial charchters\n"
read -rp "Enter the your DB name: " db_name


# Replace spaces with underscores
db_name=$(echo "$db_name" | tr ' ' '_')
echo $db_name


#DB name already exist
files=`ls`
for i in $files
do
    if [[ $db_name = $i ]]; then 
        echo -e "\n${red}Wrong Input: $db_name Data Base already exists.${white}"
        sleep 1
        return 
    fi
done

# if data base name starts with a number
if [[ $db_name =~ ^[0-9] ]]; then
    echo -e "\n${red}Wrong Input: Data Base name cannot starts with a number.${white}"
    sleep 1
    return 
fi


#if data base name contains a sepical charchters       
if [[ $db_name =~ [^a-zA-Z0-9_] ]]; then
    echo -e "\n${red}Wrong Input: DB name should not contain special characters.${white}"
    sleep 1 
    return
fi

# If all checks pass, create the DB folder
if mkdir ./${db_name}; then
    echo -e "\nDatabase '$db_name' created successfully."
    return
else
    echo -e "\nFailed to create database '$db_name'."
    return
fi





