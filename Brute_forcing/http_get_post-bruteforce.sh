#!/bin/bash

#IMPORTANT LESSON VERIABLES SHOULD NOT BE CAPITAL... 
#IT CAN CAUSE MASSIVE ISSUES

#These are the scripts main variables DO NOT TOUCH
max_var_count=19
min_var_count=5

arg_number="$#"


all_caps_false="TRUE"
cap_t_true="True"
cap_t="T"
t="t"
true="true"

all_caps_false="FALSE"
cap_f_false="False"
cap_f="F"
f="f"
false="false" 


first=$1
second=$2
third=$3
fourth=$4
fifth=$5
sixth=$6
seventh=$7
eighth=$8
ninth=$9
#after the arguments start hitting double digits the number needs to be wrapped in curley brackets {}
tenth=${10}
eleventh=${11}
twelvth=${12}
thirteenth=${13}
fourteenth=${14}
fifthteenth=${15}
sixteenth=${16}
seventeenth=${17}
eighteenth=${18}

h="-h"
hh="--h"
help="-help"
help_help="--help"

examples() {
	echo "Any option within { } is required"
	echo "If you choose to do an optional argument the previous argument is needed, even if it is optional"
	echo "(this will be switched when i switch it to marked arguments example: -p)"
	echo ""
	echo ""
	echo "Minimal Examples"
	echo ""
	echo "Example: ./Script.sh --target 'internal-administration.goodgames.htb' --user username --pass password"
	echo ""
	echo "Example: ./Script.sh domain.com user password"
	echo "Example: ./Script.sh domain.com user password_file.txt"
	echo ""
	echo "Example: ./Script.sh domain.com user_file.txt password "
	echo "Example: ./Script.sh domain.com user_file.txt password_file.txt"
	echo ""
	echo ""
	echo "Extended Examples"
	echo ""
	echo "Example: ./Script.sh {domain with the . extension} {Username or Username List} {password or password List} <The websites sub-directory> <The text displayed if credentials are incorrect> <true or false to add &submit= paramater (this is at the end of alot of websites submissions)> <Thread count>"
	echo ""
	echo "Example: ./Script.sh domain.com user password 'home/login' 'These credentials are wrong' True 45"
	echo "Example: ./Script.sh domain.com user password_file.txt 'login' 'incorrect' False 12"
}

target() {
	target="$stripped_next_arg"
}

user() {
	user_name="$stripped_next_arg"
	if [[ -e "$user_name" ]]; then
		username="-L $user_name"
	else
		username="-l $user_name"
	fi
}

pass() {
	passwords="$stripped_next_arg"
	#This checks to see if the argument exists as a file. If so it uses the password list argument, if it isnt a file it assigns the password argument 
	if [[ -e "$passwords" ]]; then
		password="-P $passwords"
	else
		password="-p $passwords"
	fi
}

subdirectory() {
	if [[ $stripped_next_arg = " " ]]; then
		#This assigns the variable sub-directory to alot of websites default, which is the login page
		sub_directory_var="login"
	else
		sub_directory_var=$stripped_next_arg
	fi
}

automated_text_grabber() {
	curl -X POST "$target/$sub_directory_var" -d "username=TestUser&password=Testpassword&login=" | grep "Wrong\|wrong\|Incorrect\|incorrect" > incorrect-text_unclean.log
	echo $(cat incorrect-text_unclean.log) > incorrect-text_clean.log
	rm incorrect-text_unclean.log
	incorrect=$(cat incorrect-text_clean.log)
	error="curl: (3) URL using bad/illegal format or missing URL"
	error_blank=""
	if [[ $incorrect == $error || $incorrect == $error_blank ]]; then
		clear
		echo "curl -X POST "$target/$sub_directory_var" -d username=TestUser&password=Testpassword&login= | grep 'Wrong\|wrong\|Incorrect\|incorrect' > incorrect-text_unclean.log"
		echo "Error while trying to automaticly grab the credential failure text"
		exit
	fi
}

incorrect_text() {
	if [[ $stripped_next_arg = " " ]]; then
		automated_text_grabber
	else
		incorrect=$stripped_next_arg
	fi
}

threads() {	
	if [[ $stripped_next_arg = " " ]]; then
		#This assigns the variable sub-directory to alot of websites default, which is the login page
		thread_count=""
	else
		thread_count="-t $stripped_next_arg"
	fi
}

login_paramater() {
	#This adds &login= to thee paramaters as default, this is because most forms have this in the tail end
	if [[ $stripped_next_arg = " " || $stripped_next_arg = "t" || $stripped_next_arg = "T" || $stripped_next_arg = "true" || $stripped_next_arg = "True" || $stripped_next_arg = "TRUE" ]]; then
		log_in="&login="
	elif [[ $stripped_next_arg = "custom" || $stripped_next_arg = "Custom" || $stripped_next_arg = "CUSTOM" || $stripped_next_arg = "c" || $stripped_next_arg = "C" ]]; then
		log_in="$stripped_next_arg"
	else
		log_in=""
	fi
}
encode_creds() {
	unencoded_user_var="^USER^"
	unencoded_password_var="^PASS^"
	encoded_user_var="^USER64^"
	encoded_password_var="^PASS64^"
	truth="$tripped_next_arg"
	#This adds &login= to thee paramaters as default, this is because most forms have this in the tail end
	if [[ $stripped_next_arg = "t" || $stripped_next_arg = "T" || $stripped_next_arg = "true" || $stripped_next_arg = "True" || $stripped_next_arg = "TRUE" ]]; then
		user_var="$encoded_user_var"
		password_var="$encoded_password_var"
		echo encoded
		echo $stripped_next_arg" does = t T true True or TRUE"
	else
		echo "unencoded"
		user_var="$unencoded_user_var"
		password_var="$unencoded_password_var"
		echo $stripped_next_arg" doesnt = t T true True or TRUE"	
	fi
}

main_function() {
	for arg in "--threads" "--target" "--user" "--pass" "--subdirectory" "--incorrect_text" "--login_paramater" "--encode_creds"; do
		if [[ $first == $arg ]]; then
			stripped_arg=$(echo $(echo $arg | sed 's/'..'\(.*\)/\1/'))
			stripped_next_arg=$second
			$stripped_arg $stripped_next_arg
		elif [[ $third == $arg ]]; then
			stripped_arg=$(echo $(echo $arg | sed 's/'..'\(.*\)/\1/'))
			stripped_next_arg=$fourth
			$stripped_arg $stripped_next_arg
		elif [[ $fifth == $arg ]]; then
			stripped_arg=$(echo $(echo $arg | sed 's/'..'\(.*\)/\1/'))
			stripped_next_arg=$sixth
			$stripped_arg $stripped_next_arg
		elif [[ $seventh == $arg ]]; then
			stripped_arg=$(echo $(echo $arg | sed 's/'..'\(.*\)/\1/'))
			stripped_next_arg=$eighth
			$stripped_arg $stripped_next_arg
		elif [[ $ninth == $arg ]]; then
			stripped_arg=$(echo $(echo $arg | sed 's/'..'\(.*\)/\1/'))
			stripped_next_arg=$tenth
			$stripped_arg $stripped_next_arg
		elif [[ $eleventh == $arg ]]; then
			stripped_arg=$(echo $(echo $arg | sed 's/'..'\(.*\)/\1/'))
			stripped_next_arg=$twelvth
			$stripped_arg $stripped_next_arg
		elif [[ $thirteenth == $arg ]]; then
			stripped_arg=$(echo $(echo $arg | sed 's/'..'\(.*\)/\1/'))
			stripped_next_arg=$fourteenth
			$stripped_arg $stripped_next_arg
		elif [[ $fifthteenth == $arg ]]; then
			stripped_arg=$(echo $(echo $arg | sed 's/'..'\(.*\)/\1/'))
			stripped_next_arg=$sixteenth
			$stripped_arg $stripped_next_arg
		else
			stripped_arg=$(echo $(echo $arg | sed 's/'..'\(.*\)/\1/'))
			stripped_next_arg=" "
			echo "the argument: "$stripped_arg" is being set automaticly to make thise easier for you :)"
			echo""
			$stripped_arg $stripped_next_arg
		fi
	done
	hydra $thread_count -I $username $password $target http-post-form /"$sub_directory_var:username=$user_var&password=$password_var$log_in:$incorrect"

}
help() {
	clear
	echo ""
	echo "Thank you for using my script 
			- YSSVirus"
	echo ""
	echo "This is the help menu for the script"
	echo "		Required Arguments
	
	--target
		This argument is for the targets domain
			Example: 
				--target example.htb

			--user
		This argument is for either a username or a user_file
			Example:
				--user username
				--user user_file.txt
		
			--pass 
		This argument is for either a password or password_file
			Example:
				--pass password
				--pass password.txt



			Optional Arguments
			
			-h
				

		--subdirectory
			This argument is for the log-in pages sub directory
				Default:
					--subdirectory login
				Example:
					the 'log-in' part of 'https://example.com/log-in'
					--subdirectory log-in
					--subdirectory hompage/other-page/log-in

		--incorrect_text
			This argument is for the text displayed when incorrect credentials are supplied
				Default:
					This script will try to automaticly detect the text that is given with incorrect credentials
				Example:
					--incorrect_text 'Wrong user or password'
					--incorrect_text wrong

		--login_paramater
			This is a true or false whether or not to include a very common paramater named submit that is set to nothing... its blank.
				Default:
					--login_paramater TRUE
					--login_paramater t
				Example:
					--login_paramater TRUE
					--login_paramater t
					--login_paramater FALSE
					--login_paramater f
		--encode_creds
			This argument is a true or false whether or not to base 64 encode the payloads
				Default:
					--login_paramater FALSE
					--login_paramater f
				Example:
					--login_paramater TRUE
					--login_paramater t
					--login_paramater FALSE
					--login_paramater f"
	echo ""
	echo""
	echo ""
	echo "Here are some Examples"
	echo ""
	examples
}
check_any_help() {
	for all_variables in "$first" "$second" "$third" "$fourth" "$fifth" "$sixth" "$seventh" "$eighth" "$ninth" "$tenth" "$eleventh" "$twelvth" "$thirteenth" "$fourteenth" "$fifthteenth" "$sixteenth" "$seventeenth" "$eighteenth"; do
		for help in "-h" "-H" "-help" "-Help" "-HELP" "-hh"; do
			if [[ "$all_variables" = "$help" ]]; then
				will_help="help"
			else 
				break 1
			fi
		done
	done
}
check_any_help
echo "$arg_number"
if [[ "$will_help" = "help" ]]; then
	help
else
	if [[ "$arg_number" -le "$min_var_count" ]]; then
		examples
		exit
	elif [[ "$arg_number" -ge "$max_var_count" ]]; then
		examples
		exit
	else
		main_function
		exit
	fi
fi
