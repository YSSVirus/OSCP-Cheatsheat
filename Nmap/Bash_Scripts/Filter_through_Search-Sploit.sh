#!/bin/bash
if [[ $# -eq 1 ]]; then
	sudo nmap -sS -p- -sV --version-intensity 9 -oA Nmap_Service_Scan $1
	searchsploit -w -v --nmap Nmap_Service_Scan.xml 
elif [[ $# -eq 2 ]]; then
	sudo nmap -sS -p- -sV --version-intensity 9 -oA $2 $1
	searchsploit -w -v --nmap $2'.xml'
elif [[ $1 = '-h' ]]; then
	echo 'script.sh <ip-addess> <filename_no-extension>'
else
	echo 'What is the ip-addess?'
	read IP
	echo '' 
	echo 'What do you want the files name to be? Dont include the extension'
	read File_Name
	echo ''
	sudo nmap -sS -p- -sV --version-intensity 9 -oA $File_Name $IP
	searchsploit -w -v --nmap $File_Name'.xml'
fi