#!/usr/bin/bash

#clear screen
clear

#welcome massage
echo -e "\nInserting data:\n"

# get table name&check
read -rp "Enter table name : " table_name

# Replace spaces with underscores
table_name=$(echo "$table_name" | tr ' ' '_')

#Check if table file doesn't exist
if [[ ! -f "./$table_name" ]]; then
    echo -e "\n${red}Error: Table '$table_name' does not exist.${white}"
    return
fi

# Get the number of lines in the metadata file
num_lines=$(wc -l < "./${table_name}_metadata")
# Initialize an array to store the row
row=()

# Loop to get values for each column
for ((i = 1; i <= num_lines; i++)); do
    # Read the i-th line from the metadata file
    line=$(sed -n "${i}p" "./${table_name}_metadata")

    # Split the line into column name, type, and PK status
    IFS=':' read -r col_name col_type is_pk <<< "$line"

    # Display the column name
    echo "Column name: $col_name"
    echo "Column type: $col_type"
    echo "is PK: ${is_pk}"

    # Ask the user to input values for the column
    while true; do
        echo "Enter value for column '$col_name'"
        read -r value

        # Check if the column is a primary key
        if [[ "$is_pk" == "PK" ]]; then
            # If it's a PK, ensure at least one value is entered
            if [[ -z "$value" ]]; then
                echo -e "${red}Error: Primary key column cannot be empty. Please try again.${white}"
                continue
            fi

            # Check if the PK value already exists in the first column of the table
            if cut -d':' -f1 "./$table_name" | grep -q "^$value$"; then
                echo -e "${red}Error: Value '$value' already exists in the primary key column '$col_name'. Please try again.${white}"
                continue
            fi

        else
            # If it's not a PK and no value is entered, set it to NULL
            if [[ -z "$value" ]]; then
                value="NULL"
            fi
        fi

        # Validate data type
        if [[ "$col_type" == "int" ]]; then
            # Check if all values are integers
            if ! [[ "$value" =~ ^[0-9]+$ || "$value" = 'NULL' ]]; then
                echo -e "${red}Error: '$value' is not a valid integer for column '$col_name'. Please try again.${white}"
                continue 
            fi
        fi

        # If all validations pass, break the loop
        break
    done

    # Add the value to the row array
    row+=("$value")
done

# Join the row array with ':' and write to the table file
row_string=$(IFS=":"; echo "${row[*]}")
echo "$row_string" >> "./$table_name"
echo  "Data inserted successfully into $table_name table."



