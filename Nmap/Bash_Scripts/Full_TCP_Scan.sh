#!/bin/bash
#The following variable will make the help menu -h as I dont think I can define it straight in the if, elif, else function
help="-h"
echo "Thank you for using YSSVirus's quick tcp scanning script"
echo ""
#The following allows a help menu it checks for the help argument, and then if  it gets it, it displays help,,, if not it moves to the program.
if [ $1 = $help ]
then
	echo ""
        echo "Thank you for using my script my name is YSSVirus,
        It is a relatively simple script.
        It is runnable with just the script, no arguments for an interactive prompt through or run the script with 1 or 2 arguments first being host second being file name to save it as (no extension)"
        echo ""
        echo Example
        echo ""
        echo "And always remember... Try Harder!!!"
else
#The following will test if there is any arguments
if [ $# -eq 0 ]
   then
    clear
   echo "This script can be an like this but also with arguments"
   echo ""
#The following creats a function out of an Example I use multiple times.
   function Example {
   echo "Example: quick_port-scanner.sh '<host-or-range-of-hosts-to-scan>' 'file-name-no-extension'"
}
Example
   echo ""
   echo "What is the hosts ip or range of ip's?"
#Below is asking for the Targets ip or ip range
   read Host
   echo ""
   echo "Do you wish to save the output? (yes or no (no uppercase))"
   read output_answer
   echo ""
        if [ "$output_answer" = "yes" ]
        then
         echo "What name should this save under? (No extension)"
         read filename
	 sudo nmap -sS -p- -oN "$filename".txt "$Host"
        elif [ "$output_answer" = "no" ]
        then
         sudo nmap -sS -p- "$Host"
#The following makes it so it defaults to saving a log under my handel     
else
         echo "You typed in a incorrect response... defaulting to a saved copy under YSSVirus.txt"
	 filename="YSSVirus"
	 sudo nmap -sS -p- -oN "$filename".txt "$Host"
        fi
#The following checks to see if there is only one argument (the host IP/range)
elif [ $# -eq 1 ]
        then
        sudo nmap -sS -p- "$1"
        #The following checks to see if there is 2 arguments (the host IP/range followed by a filename)
elif [ $# -eq 2 ]
        then
         sudo nmap -sS -p- -oN "$2".txt "$1"
#The following will make sure there there isnt to many arguments
else
        echo "I'm sorry. You entered in to many arguments its at maximum 2!"
        echo ""
        Example
fi
fi
