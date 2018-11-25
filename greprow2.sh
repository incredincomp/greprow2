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


nextSearch () {
getPath2
whatFind
grepAppend
nextStep
}

#needPath () {
#}

getPath2 () {
#this is a function set up to call a dialog box for user to select a file to parse 
prompt="Please select a file:"
options=( $(find -maxdepth 1 -print0 | xargs -0) )

PS3="$prompt "
select opt in "${options[@]}" "Quit" ; do
        if (( REPLY == 1 + ${options[@]} )) ; then
	    exit
		
		
	elif (( REPLY > 0 && REPLY <= ${#options[@]} )) ; then
	    echo "You picked $opt which is file $REPLY"
	    break
		
	else
	    echo "Invalid option. Try again." ;
	fi
done
}

#read -p "Please type your full file path, starting with a backslash if it is absolute. It's more than likely equal to $PWD/file.txt: " inputPath

getPath () {
clear
printf " If you would like to define your own path, please press y.  Pressing n will set your path as $PWD/log.txt. "
echo "  "
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
while true; do
    echo "  "
    echo -n "y or n: " 
    read answer
#    echo "  "
#    echo "______________________________________________________________"
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    case $answer in
# in theory, the "return 1 and 0's" should allow this to error check in a sense. to be tested, 
# https://unix.stackexchange.com/questions/268764/how-to-repeat-prompt-to-user-in-a-shell-script
                [yY] )
#                       clear
                       echo "__________________________________________________"
                       read -p "Please type your full file path, starting with a backslash if it is absolute. It's more than likely equal to $PWD/file.txt: " inputPath
                       return 0
                       ;;

                [nN] )
#                       clear
                       echo "Okay, we're going to just use $PWD/log.txt for you."
                       inputPath="$PWD/log.txt"
	    	       return 0
		       ;;

                   * ) 
#                       clear
	               echo "Invalid input"
                       return 1
		       ;;
    esac
done
}

whatFind () { 
echo "	"
echo -n "What linformation would you like to find? "
read lookFor
echo "	"
echo "Looking for $lookFor... Please wait... "
echo "Search Start Time : " $(date -u)
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
}

grepAppend () {
#I dont know why this works, how or if it even should.  This while statement shows my naivety to bash scripting though.
###DO NOT TOUCH!!!! THIS SHOULDNT WORK, SO THEREFORE ITS PERFECTLY BROKEN AS IS!!!!###
while : 
 do
      grep -i $lookFor $inputPath >> $lookFor.txt 
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
	nextStep
      fi
    done
}



nextStep () {
echo "	"
echo -n "Would you like to run another search? [y or n]: "
read reFind
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
case $reFind in
            [yY] )
	    nextSearch
	    
	    
	    ;;
	    [nN] )
	    echo "Okay, I hope you found me useful! See you next time!"
            printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
            exit
	    ;;
esac
}



getPath2
whatFind
grepAppend
nextStep
