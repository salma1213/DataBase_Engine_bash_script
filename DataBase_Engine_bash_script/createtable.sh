#!/usr/bin/bash

#clear screen
clear


# get table name&check
read -rp "Enter table name : " table_name

# Replace spaces with underscores
table_name=$(echo "$table_name" | tr ' ' '_')

#Table name already exist
files=`ls`
for i in $files
do
    if [[ $table_name = $i ]]; then 
        echo -e "\n${red}Wrong Input: $table_name Table already exists.${white}"
        sleep 1
        return 
    fi
done

# if table name starts with a number
if [[ $table_name =~ ^[0-9] ]]; then
    echo -e "\n${red}Wrong Input: Table name cannot starts with a number.${white}"
    sleep 1
    return 
fi


#if table name contains a sepical charchters       
if [[ $table_name =~ [^a-zA-Z0-9_] ]]; then
    echo -e "\n${red}Wrong Input: Table name should not contain special characters.${white}"
    sleep 1 
    return
fi

# If all checks pass, create the table file
if touch ./${table_name}; then
    touch ./${table_name}_metadata
    echo -e "\nTable '$table_name' created successfully."
else
    echo -e "\nFailed to create Table '$table_name'."
    return
fi

#Then get the meta data 
while true; do
    read -rp "Enter the number of cols in $table_name : " num_col
    # Check if the input is a valid number
    if ! [[ "$num_col" =~ ^[1-9]+$ ]]; then
        echo -e "\n${red}Error: Please enter a valid number.${white}"
    else
        break
    fi
done

# Array to store column names
declare -a columns
# Loop to get metadata for each column
for ((i = 1; i <= num_col; i++)); do
    if [[ $i -eq 1 ]]; then
        echo -e "\nColumn $i is the Primary Key (PK)."
    else
        echo -e "\nColumn $i:"
    fi

    # Get column name
    while true; do
        read -rp "Enter the name of column $i: " col_name
        # Replace spaces with underscores
        col_name=$(echo "$col_name" | tr ' ' '_')
        #check the validity of the name
        if [[ $col_name =~ ^[0-9] || $col_name =~ [^a-zA-Z0-9_] ]]; then
            echo -e "\n${red}Wrong Input: Coulmn name cannot starts with a number nor contains special characters.${white}"
            sleep 1 
            continue 
        fi
        # Check if column name already exists
        if [[ " ${columns[@]} " =~ " ${col_name} " ]]; then
            echo -e "\n${red}Error: Column name '$col_name' already exists.${white}"
            sleep 1
            continue
        else
            columns+=("$col_name")  # Add column name to the array
            break
        fi
    done


    # Get column data type
    while true; do
        read -rp "Enter the data type of column $i (str/int): " col_type
        if [[ "$col_type" == "str" || "$col_type" == "int" ]]; then
            break
        else
            echo -e "${red}Error: Invalid data type. Please enter 'str' or 'int'.${white}"
        fi
    done

    # Save metadata to the table file
    if [[ $i -eq 1 ]]; then
        echo "$col_name:$col_type:PK" >> "./${table_name}_metadata"
    else
        echo "$col_name:$col_type" >> "./${table_name}_metadata"
    fi
done
echo "The cols has been added successfully"

