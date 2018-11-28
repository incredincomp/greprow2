#!/bin/bash - 
#===============================================================================
#
#          FILE: greprow2.sh
# 
#         USAGE: sudo ./greprow2.sh 
# 
#   DESCRIPTION: Enter any information that could be contained in your list, this will
#		pull the entire line that is related to that search term and print/append the data
#		to a new file with the name of the search issued.  needs format work,
#		much apologies
# 
#       OPTIONS: ---
#  REQUIREMENTS: you need to have a .txt file in a location you know
#		
#          BUGS: none as far as I know of in its current state
#         NOTES: v1.2.2
#        AUTHOR: @incredincomp & @Venom404
#  ORGANIZATION: 
#       CREATED: 09/20/2018 06:32:54 PM
#      REVISION:  11/27/2018 10:35:00 AM
#===============================================================================

set -o nounset                              # Treat unset variables as an error

#this is just a weird function that I dont think i need.  at the end tho, part of the switch case calls for a repeat of the
#program functions so hey, why not make it easier on the program and compile it here?
next_Search () {
yes_no
what_Find
grep_Append
next_Step
}

#function to ask user if they would like to define their own file path, if not, the program declares greprow2/log.txt as input
yes_no () {
dialog --title "Define your own file/path?" \
--yesno "If you select no, $PWD/log.txt will be used." 7 60
response=$?
case $response in
    0)
    #send user to set_Path dialog
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

#this function brings up a dialog menu to help you select your file path.  dialog boxes are slightly difficult to navigate for
#noobs so i need to figure out either a way to tell a user how to use it, or change the set_Path function again
set_Path () {
DIALOG=${DIALOG=dialog}

FILEPATH=`$DIALOG --stdout --title "Please choose a file" --fselect $HOME/ 14 48`
if [ -e "$FILEPATH" ]
then 
   case $? in
       0)
               clear
                
               echo "\"$FILEPATH\" chosen";;
       1)
               clear
               echo "Cancel pressed."
               yes_no
               ;;
       255)
               clear
               echo "Box closed."
               yes_no
               ;;
   esac
else
    yes_no
fi
}


#this function collects the variable that is used to search the specified file and stores it as lookFor
what_Find () {  
echo "	"
echo -n "What information would you like to find? "
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

trick_Step () {
next_Step
}
#this function is the final slide of the actual program. this will just ask if you would like to restart the program for another
#search
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
	    
	    *) 
	    echo "ERROR. Please press y or n."
	    trick_Step
            ;;
esac
}


#once bash finishes reading functions, the initial search is called here.  When getting to next_Step, if user selects yes
#next_Search will be called which is another previously declared function including these same commands.
yes_no
what_Find
grep_Append
next_Step
