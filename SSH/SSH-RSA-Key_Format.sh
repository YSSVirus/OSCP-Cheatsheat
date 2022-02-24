#!/bin/bash
#The following if then statement will check for one argument which should be exact file path of the RSA ssh key the user wants to format
if [[ $# -eq 1 ]]; then
	#The following variable allows us to later call the working dirrectory in a echo command
	working_directory=$(pwd)
	#The following adds the beginning line to the properly formatted ssh key
	echo "-----BEGIN OPENSSH PRIVATE KEY-----" > ssh_key_formatted
	#The following converts the actual key info to the proper format. It removes all spaces and replaces them with new lines.
	cat $1 | tr " " "\n" | grep -v "END\|OPENSSH\|PRIVATE\|KEY\|BEGIN" >> ssh_key_formatted
	#The following then ends the last line in. It should auto add thee empty space at the end of the key
	echo "-----END OPENSSH PRIVATE KEY-----" >> ssh_key_formatted
	chmod 600 ssh_key_formatted
	echo""
	echo "The following key has been properly formatted " 
	echo $1
	echo ""
	echo "It is now located at"
	#Here we add the working directory combined with the new key name so it is the proper full path of the new file
	echo  $working_directory"/ssh_key_formatted"
else
	echo "This command needs to be run with a full file path of the unformated SSH key"
	echo "Example: ssh_format.sh /tmp/unformatted_ssh_key"
fi
