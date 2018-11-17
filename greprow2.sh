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

getPath () {
echo " If you would like to define your own path, please press y. Otherwise, if you want this program to break, please press n. "
echo -n "y or n: " 
read answer
case $answer in

            [yY] )
                   read -p "Please type your full file path, starting with a backslash if its absolute. Its more than likely equal to $PWD/file.txt: " inputPath

                   ;;

            [nN] )
                   echo "okay, were going to just use $PWD/log.txt for you."
                   inputPath="$PWD/log.txt"
		   ;;

            * ) echo "Invalid input"
                continue
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
###2.)searches in file (indicated in this script,) for any version of the $lookFor variable and makes 
###a seperate file $lookFor.txt in same directory as input file. It copys the
###whole matching line to new file or appends to the file that already exists if set up as CRON job. 
      if [ $? -eq 0 ] ; then
        echo "$lookFor found and writing to file, check current directory for $lookFor.txt"
	exit
      else
        echo "Error, $lookFor not found in specified file."
	exit
      fi
    done
echo "Search ended at" $(date -u)
}

nextStep () {
echo -n "Would you like to run another search? "
read reFind
case $reFind in
            [yY] )
	    nextSearch
	    
	    
	    ;;
	    [nN] )
	    echo "Okay, thanks for finding me useful! See you next time!"
	    exit
	    ;;
}

nextSearch () {
getPath
whatFind
grepAppend

}

getPath
whatFind
grepAppend
nextStep
