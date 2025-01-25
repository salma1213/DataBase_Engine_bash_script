#!/usr/bin/bash

# Clear the screen
clear

# Ask for the table name
read -rp "Enter the table name: " tablename

# Replace spaces with underscores
tablename=$(echo "$tablename" | tr ' ' '_')

# Loop until the table is found
while true; do
    # Check if the table file and metadata file exist
    if [[ -f "$tablename" && -f "${tablename}_metadata" ]]; then
        echo -e "\nTable found: $tablename"

        # Display menu of options for the user to choose from
        echo "1. Select all"
        echo "2. Select column"
        echo "3. Select by column"
        echo "4. Exit"

        # Ask the user for their choice
        read -rp "Please choose an option (1, 2, 3, or 4): " choice

        case $choice in
            1)
             # Option 1: Select all
                cat "$tablename"
                ;;

            2) 
            # Option 2: Select column
                echo "Available columns:"
                # Extract only the column names (before the first colon, ignoring type and PK)
                column_names=$(awk -F: '{print $1}' "${tablename}_metadata")

                # Display column names line by line
                echo "$column_names"

                # Ask the user for the column name
                read -rp "Enter the column name: " column

                # Find the column number in the metadata
                colnum=$(echo "$column_names" | grep -nx "$column" | cut -d: -f1)

                if [[ -n "$colnum" ]]; then
                    # Display the selected column
                    cut -d: -f"$colnum" "$tablename"
                else
                    echo "Error: Column '$column' not found."
                fi
                ;;

            3) 
            # Option 3: Select by column
                echo "Available columns:"
                # Extract only the column names (before the first colon, ignoring type and PK)
                column_names=$(awk -F: '{print $1}' "${tablename}_metadata")

                # Display column names line by line
                echo "$column_names"

                # Ask the user for the column name
                read -rp "Enter the column name: " column

                # Find the column number in the metadata
                colnum=$(echo "$column_names" | grep -nx "$column" | cut -d: -f1)

                if [[ -n "$colnum" ]]; then
                    # Ask for the value to search
                    read -rp "Enter the value to search: " value

                    # Use awk to search for the value in the column
                    awk -F: -v col="$colnum" -v val="$value" '$col == val {print $0}' "$tablename"
                else
                    echo "Error: Column '$column' not found."
                fi
                ;;

            4) 
            # Option 4: Exit
                echo "Exiting the program..."
                sleep 1
                break
                ;;

            *) 
            # Handle invalid choices
                echo "Invalid choice. Please select a valid option."
                ;;

        esac
    else
        # If the table or metadata file does not exist
        echo "Error: Table '$tablename' or its metadata does not exist."
        read -rp "Please enter a valid table name: " tablename
    fi
done
