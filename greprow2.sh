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
getPath
whatFind
grepAppend
nextStep
}

getPath () {
echo " If you would like to define your own path, please press y. Otherwise, if you want this program to break, please press n. "
echo -n "y or n: " 
read answer
case $answer in
# in theory, the "return 1 and 0's" should allow this to error check in a sense. to be tested, 
# https://unix.stackexchange.com/questions/268764/how-to-repeat-prompt-to-user-in-a-shell-script
            [yY] )
                   read -p "Please type your full file path, starting with a backslash if its absolute. Its more than likely equal to $PWD/file.txt: " inputPath
                   return 0
                   ;;

            [nN] )
                   echo "okay, were going to just use $PWD/log.txt for you."
                   inputPath="$PWD/log.txt"
		   return 0
		   ;;

               * ) 
	           echo "Invalid input"
                   return 1
		   ;;
esac
}

whatFind () { 
echo -n "What lines would you like to find? "
read lookFor
echo "Looking for $lookFor... please wait" | echo "Search Start Time : " $(date -u)
}

grepAppend () {
#I dont know why this works, how or if it even should.  This while statement shows my naivety to bash scripting though.
###DO NOT TOUCH!!!! THIS SHOULDNT WORK, SO THEREFORE ITS PERFECTLY BROKEN AS IS!!!!###
while : 
 do
      grep -i $lookFor $inputPath >> $lookFor.txt 
      if [ $? -eq 0 ] ; then
        echo "$lookFor found and writing to file, check current directory for $lookFor.txt"
        echo "Search ended at" $(date -u)
	break
      else
        echo "Error, $lookFor not found in specified file."
	nextStep
      fi
    done
}



nextStep () {
echo -n "Would you like to run another search? [y or n] "
read reFind
case $reFind in
            [yY] )
	    nextSearch
	    
	    
	    ;;
	    [nN] )
	    echo "Okay, thanks for finding me useful! See you next time!"
	    exit
	    ;;
esac
}



getPath
whatFind
grepAppend
nextStep
