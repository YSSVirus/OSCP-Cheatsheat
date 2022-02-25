#!/bin/bash
#This is where the welcome message variable is stored
#I made this a variable so I can call and change it easier
Welcome_Message='Hi thank you for using YSSVirus linux Enumerator!!!'
echo $Welcome_Message
sleep 2
echo ""
echo "We will start running some arbitary commands to get basic info"
echo ""
echo "The following checks the enviorment variables: "
env
echo ""
echo ""
echo ""e
cho "The systems OS info is the following: "
uname -a
echo ""
cat /etc/*-release
echo ""
echo ""
echo ""
echo "This targets hostname is: "
echo ""
hostname
echo ""
echo ""
echo ""
echo "The bash history is as follows: "
echo ""
history
echo ""
echo ""
echo ""
echo "The cron job info is as follows: "
echo ""
find / -name "*cron*.*" 2> /dev/null
echo ""
echo ""
echo ""
echo "Checking for any password files!"
echo ""
find / -name "*cron**" 2> /dev/null | grep -v "service\|dpkg\|/usr/share/man\|/usr/share/doc/cron/examples/\|/usr/lib/modules/*\|/usr/share/vim/\|/usr/share/bug/cron\|/usr/share/doc/cron\|/usr/share/doc/passwd/examples/passwd.expire.cron" > cron-job_list
	while IFS="" read -r p || [ -n "$p" ]; do printf '\n'$p'\n' && ls -la $p ; done < cron-job_list > cron-job_list_formatted
	printf 'These are all of the cronjobs \n' $transfer_cat
	cat cron-job_list_formatted
echo ""
echo ""
echo""
#Now this is where the script starts to search for any files with the word password or anything of the similar
#The initial find searches for "passwd"
echo "Found password files are as follows: "
find / \( -name "shadow" -o -name "passwd" -o -name "passwd.*" -o -name "pass" -o -name "password" -o -name "pass.*" -o -name "password.*" -o -name "ssh_*" \) 2>/dev/null
echo ""
echo ""
echo ""
echo "Sudo info: "
echo ""
sudo -V
echo ""
echo ""
echo ""
echo "The usernames on this target are as follows: "
echo ""
cat /etc/passwd
echo ""
echo ""
echo ""
echo "The groups on the target are as follows: "
echo ""
cat /etc/group
echo ""
echo ""
echo ""
echo "The following is all of the cron jobs:"
echo ""
ls -laR /etc/cron*
echo ""
echo ""
echo ""
echo "All drives mounted at boot are listed below:"
echo ""
cat /etc/fstab
echo ""
mount
echo ""
echo ""
echo ""
echo "The following are all files owned by root but changable by others: "
echo ""
find -P / -type f -executable -user root -perm -o=w -name '*' 2>/dev/null -exec ls -la {} \;
echo ""
echo ""
echo ""
echo "The files listed below have a set UID (This means thee are ran at root level no pass needed): "
echo ""
find -P / -type f -executable -user root -perm -o=w,u=s -name '*' 2>/dev/null -exec ls -la {} \;
echo ""
echo "Lists all backup files: "
find / -name *.bak 2>/dev/null -exec ls -la {} \;
echo ""
echo "Finding info related to ssh_keys: "
echo ""
locate *_key*
echo ""
locate *rsa*
echo ""
find / -name *private* -type f -readable 2>/dev/null -exec ls -la {} \;
echo ""
find / -name *_key* -type f -readable 2>/dev/null -exec ls -la {} \;
echo ""
echo ""
echo ""
echo "Getting network info: "
echo ""
ifconfig -v -a
echo ""
ss
echo ""
netstat -a -n -p
echo ""
echo ""
echo ""
echo "Finding all config files: "
echo ""
find / -name "*.conf" 2>/dev/null
