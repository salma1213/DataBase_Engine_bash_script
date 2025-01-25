#!/usr/bin/bash

# Clear the screen
clear

while true; do
    read -rp "Enter Table Name: " tablename

    # Check if the table exists
    if [ -f "$tablename" ]; then
        echo "1. Update by ID"
        echo "2. Update column"
        read -rp "Choose an option (1 or 2): " choice

        case $choice in
            1)
                # Update by ID
                # Ask for the ID to update
                read -rp "Enter the ID you want to update: " id

                # Check if the ID exists in the first column
                if grep -q "^$id:" "$tablename"; then
                    # Display only the column names (skip data type and PK)
                    echo "Available columns: "
                    # Extract column names from the metadata file, skipping the data type and PK
                    awk -F: '{print $1}' "${tablename}_metadata" | tail -n +2

                    # Ask for the column to update
                    read -rp "Enter the column name to update: " column

                    # Find the column number in the metadata file (skip data type and PK)
                    colnum=$(awk -F: -v col="$column" '$1 == col {print NR}' "${tablename}_metadata")

                    if [[ -n "$colnum" ]]; then
                        # Get the current value for the specified column and ID
                        oldvalue=$(awk -F: -v id="$id" -v col="$colnum" '$1 == id {print $col}' "$tablename")
                        echo "Current value: $oldvalue"

                        # Ask for the new value
                        read -rp "Enter the new value: " newvalue

                        # Update the table
                        awk -F: -v id="$id" -v col="$colnum" -v new="$newvalue" 'BEGIN {OFS=FS} $1 == id {$col=new} {print}' "$tablename" > temp && mv temp "$tablename"
                        echo "Value updated successfully!"
                        break
                    else
                        echo "Column not found."
                    fi
                else
                    echo "ID not found."
                fi
                ;;

            2)
                # Update a column
                # Display only the column names (skip data type and PK)
                echo "Available columns:"
                # Extract column names from the metadata file, skipping data types and PK
                awk -F: '{print $1}' "${tablename}_metadata" | tail -n +2

                # Ask for the column to update
                read -rp "Enter column name to update: " column

                # Find the column number in the metadata file (skip data type and PK)
                colnum=$(awk -F: -v col="$column" '$1 == col {print NR}' "${tablename}_metadata")

                if [[ -n "$colnum" ]]; then
                    # Display current data in the column
                    echo "Current data in $column: "
                    awk -F: -v col="$colnum" 'NR>1 {print $col}' "$tablename"

                    # Ask for the old value
                    read -rp "Enter the value you want to update: " oldvalue

                    # Check if this value exists in the column
                    if awk -F: -v col="$colnum" -v val="$oldvalue" '$col == val' "$tablename"; then
                        # Ask for the new value
                        read -rp "Enter the new value: " newvalue

                        # Update the table
                        awk -F: -v col="$colnum" -v old="$oldvalue" -v new="$newvalue" 'BEGIN {OFS=FS} $col == old {$col=new} {print}' "$tablename" > temp && mv temp "$tablename"
                        echo "Update successful"
                    else
                        echo "Value not found in the column"
                    fi
                else
                    echo "Column not found."
                fi
                ;;

            *)
                echo "Invalid choice"
                ;;
        esac
    else
        echo "Table not found"
    fi
done
