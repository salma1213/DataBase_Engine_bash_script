#!/usr/bin/bash
LC_COLLATE=C  #Terminal Case sensitive
shopt -s extglob  #Enable subpattern in case statment

#clear screeen
clear
#Red Color for wrong inputs
export  red='\033[1;31m'
export white='\033[0m'

#welcome massage
echo "Hello, Welcome to ITIAIAN Data Base Server."


#loop to display menu
while true; do
	read  -rp "Main Menue.
1- Creat DB
2- Display DB 
3- Remove DB
4- Connect to DB
5- Exit " -n1 usr_choice

	# if user input is not a number
	if [[ ! $usr_choice = [0-9] ]]; then
    	echo -e "${red}\nWrong Input: Please type a number.${white}"
		sleep 1
        continue
    fi

	case $usr_choice in 
		1)
			source createDB.sh
		;;
		2)
			source DisplayDB.sh
		;;
		3)
			source removeDB.sh
		;;
		4)
			source connectDB.sh
		;;
		5)
		echo -e "\nsee you soon"
		sleep 1
		break

		;;
		*)
		echo -e "\n${red}Wrong Input: Please Choose again.${white}"
		sleep 1
		#clear screen
	esac

done
