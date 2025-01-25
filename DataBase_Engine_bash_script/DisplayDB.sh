#!/usr/bin/bash

#clear screen
clear

echo -e "\nDisplaying existing data bases:\n"


# Check if any databases exist
if [[ -z "$(ls -F | grep  / )"  ]]; then
    echo -e "${red}No databases found.\n${white}"
else
    ls -F | grep /
    echo -e "\n"
fi 
