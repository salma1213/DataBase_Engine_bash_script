#!/usr/bin/bash
export LC_COLLATE=C
shopt -s extglob

clear
read -rp "please enter the name of the table: " tablename

#check if the table exist
if [[ ! -f "$tablename" ]]; then
    echo -e "${red}Error: table '$tablename' does not exist${white}"
    return
fi

#display delete options
echo "choose delete option: "
echo "1. delete the table "
echo "2. delete a column "
echo "3. delete by ID "

read -rp "Enter your choice (1, 2, or 3): " choice

case $choice in
    1)
        #option 1
        read -rp "Are you sure you want to delete the enire table '$tablename'? (yes/no): " confirmation
        if [[ "$confirmation" == "yes" ]]; then
            rm "$tablename"
            rm "$tablename"_metadata

            echo "Table '$tablename' has been successfully deleted"
        else
            echo -e "${red}Error: The table was not deleted${white}"
        fi
        ;;
    
    2)
        #option 2
        echo "The available columns are:"
        # Extract column names (skip data types and 'PK')
        awk -F: '{print $1}' "$tablename"_metadata | sed '1d'  # Skipping the first line if it's for the PK
        read -rp "Enter the name of the column you want to delete: " column

        # Get the column number for the selected column
        colnum=$(awk -F: -v col="$column" 'NR==1 {for (i=1; i<=NF; i++) if ($i == col) print i}' "$tablename"_metadata)

        if [[ -n "$colnum" ]]; then
            # Remove the selected column from the table
            awk -F: -v col="$column" 'BEGIN {OFS=FS} {
                for (i=1; i<=NF; i++) {
                    if (i != col){
                        printf "%s%s", $i, (i<NF?FS:"")
                    }
                } 
                print ""
            }' "$tablename" > temp && mv temp "$tablename"

            # Remove the metadata of the deleted column
            awk -F: -v col="$column" 'BEGIN {OFS=FS} {
                for (i=1; i<=NF; i++) {
                    if ($i != col) {
                        printf "%s%s", $i, (i<NF?FS:"")
                    }
                }
                print ""
            }' "$tablename"_metadata > temp_metadata && mv temp_metadata "$tablename"_metadata

            echo "Column '$column' has been successfully deleted from the table"
        else
            echo -e "${red}Error: Column '$column' does not exist${white}"
        fi
        ;;

    3)
        #option 3
        read -rp "Enter ID number: " id
        if grep -q "^$id:" "$tablename"; then
            #use grep to exclude the matching row
            grep -v "^$id:" "$tablename"> temp && mv temp "$tablename"
            echo "Record deleted successfully"
        else
            echo -e "${red}Error ID '$id' does not exist in the table${white} "
        fi
        ;;
    
    *)
        echo -e "${red}invalid choice${white}"
        ;;
esac