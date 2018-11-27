#!/bin/bash - 
#===============================================================================
#
#          FILE: greprow2.sh
# 
#         USAGE: ./greprow2.sh 
# 
#   DESCRIPTION: Enter any information that could be contained in your list, this will
#		pull the entire line that is related to that name and print/append the data
#		to a new file with the name of the search issued.  needs format work,
#		much apologies
# 
#       OPTIONS: ---
#  REQUIREMENTS: you need to have the .txt file in a location you know, and put that
#		path in as the input in comment #1
#          BUGS: none as far as I know of in its current state
#         NOTES: v1.1.1
#        AUTHOR: @incredincomp & @Venom404
#  ORGANIZATION: 
#       CREATED: 09/20/2018 06:32:54 PM
#      REVISION:  11/17/2018 11:45:00 AM
#===============================================================================

set -o nounset                              # Treat unset variables as an error


welcome_Banner () {
echo " _    _        _                                _           _____                                         _____ ";
echo "| |  | |      | |                              | |         |  __ \                                       / __  \";
echo "| |  | |  ___ | |  ___  ___   _ __ ___    ___  | |_  ___   | |  \/ _ __  ___  _ __   _ __  ___ __      __\`' / /'";
echo "| |/\| | / _ \| | / __|/ _ \ | '_ \` _ \  / _ \ | __|/ _ \  | | __ | '__|/ _ \| '_ \ | '__|/ _ \\ \ /\ / /  / /  ";
echo "\  /\  /|  __/| || (__| (_) || | | | | ||  __/ | |_| (_) | | |_\ \| |  |  __/| |_) || |  | (_) |\ V  V / ./ /___";
echo " \/  \/  \___||_| \___|\___/ |_| |_| |_| \___|  \__|\___/   \____/|_|   \___|| .__/ |_|   \___/  \_/\_/  \_____/";
echo "                                                                             | |                                ";
echo "                                                                             |_|                                ";
}

next_Search () {
yes_no
what_Find
grep_Append
next_Step
}

yes_no () {
dialog --title "Define your own file/path?" \
--yesno "If you select no, $PWD/log.txt will be used." 7 60
response=$?
case $response in
    0)
    #send user to get path dialog
        clear
        set_Path
	
	;;
    1)
        clear
	echo "Okay, we set the path as $PWD\log.txt."
	FILEPATH="$PWD/log.txt"
	;;
    255)
        clear
	echo "[ESC] key pressed."
	;;
esac
}

set_Path () {
DIALOG=${DIALOG=dialog}

FILEPATH=`$DIALOG --stdout --title "Please choose a file" --fselect $HOME/ 14 48`

case $? in
	0)
		clear
		welcome_Banner
		echo "\$FILEPATH" chosen";;
	1)
		clear
		echo "Cancel pressed.";;
	255)
		clear
		echo "Box closed.";;
esac
}



what_Find () { 
echo "	"
echo -n "What information would you like to look for? "
read lookFor
echo "	"
echo "Looking for $lookFor... Please wait... "
echo "Search Start Time : " $(date -u)
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
}

grep_Append () {
#I dont know why this works, how or if it even should.  This while statement shows my naivety to bash scripting though.
###DO NOT TOUCH!!!! THIS SHOULDNT WORK, SO THEREFORE ITS PERFECTLY BROKEN AS IS!!!!###
while : 
 do
      grep -i $lookFor $FILEPATH >> $lookFor.txt 
      if [ $? -eq 0 ] ; then
        echo "	"
        echo "$lookFor found and writing to file, check current directory for $lookFor.txt"
        echo "Search ended at " $(date -u)
        printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
	break
      else
        echo "	"
        echo "Error, $lookFor not found in specified file."
        printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
	next_Step
      fi
    done
}



next_Step () {
echo "	"
echo -n "Would you like to run another search? [y or n]: "
read reFind
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
case $reFind in
            [yY] )
	    next_Search
	    
	    
	    ;;
	    [nN] )
	    echo "Okay, I hope you found me useful! See you next time!"
            printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
            exit
	    ;;
esac
}



yes_no
what_Find
grep_Append
next_Step
