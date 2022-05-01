#!/bin/bash
#Here is where we define our variables that need to be pre defined
#This a simple x value used for creating unique files then combining them 
x=1 #this is where we simply store a number used later on in combining files
domain_value=$1 # here is where we store the first arguent.... they act weird unless stored in a variable
urls_subfinder='subfinder.log' # this is more something for later it holds a frequently refrencedfiles value
bruteforce_list=$2 #This is the list we will use fore brute forcing later

#Here we start the functions
#Here is the function for gathering urls via gau
gau_func(){
	echo ''
	echo 'starting gau scan on subfinder results'
	#This is where we gather urls from gau. It will use the subfinders results
	cat $urls-subfinder | gau -subs -t 10 -o gau.log
}
#Here is the function where we grab the standard wayback urls
waybackurls_func(){
	echo ''
	echo 'Starting waybackurls scan on gau results'
	echo ''
	#Here we get waybackurls on the subfinder output. I did this as subfinder doesnt produce to many results but does get a wide grasp of things allowing waybackurls to go more in depth
	cat $urls_subfinder | waybackurls > waybackurls.log
}
#Here is where we use dome to gath misc info and some more directories
dome_func(){
	#Here we define a few variables that we need
	#This is where we save our loggers directory for easy access again later
	our_directory=$(pwd)
	#This is where we locate the dome.py file and cd into its directory 
	dome_directory=$(locate /Dome/dome.py | awk '{print substr($0, 1, length($0)-'8')}') #I used this awk command so I could specificly identify the file then I grabbed that path and awk is what allowed me to shrink it down to the path
	cd $dome_directory
	python3 dome.py -m active -d $here -w wordlists/top1million.txt --resolvers $directory/"resolvers.txt" --top-100-ports -t 75 -nb -ip -o $directory/dome'.log'
	cd $our_directory
}
#Here is where we combine the logs so its more compiled while most logs remain there going to be in a seperate folder for easy deletion if the user wants
combine_logs(){
	#Here is where we start combining and checking files
	# the checks preformed are checking for duplicates and checking if there inscope
	cat * | anew -t urls.log
	cat urls.log | inscope > inscope_urls.log
	mv urls.log ../urls.log
	mv inscope_urls.log ../inscope_urls.log
	mkdir old_logs
	mv * old_logs
	mv ../urls.log urls.log
	mv ../inscope_urls.log inscope_urls.log
	cat urls.log | fff -S -o all_urls # this command and one other are not like the rest this command will gather urls
	cd urls-gathered
	mkdir waybackurls
	cd waybackurls
	mv ../../waybackurls.log waybackurls.log
	cat ../../urls.log | waybackurls -get-versions | fff -S # this is the other command that is not like the others. It grabs all versions of urls from the waybackmachine
	cd ../../
}


if [[ $domain_value = "-h" || $domain_value = "--h" || $domain_value = "-help" || $domain_value = "--help" || $bruteforce_list = "-h" || $bruteforce_list = "--h" || $bruteforce_list = "-help" || $bruteforce_list = "--help" ]]; then
  	#statements  #Here is where we offer help
	echo "bash script.sh <target or full file location> <full file location for bruteforce list>"
	echo ""
	echo "bash script.sh google.com /home/user/wordlists/domains.txt"
	echo "bash script.sh /home/user/Targets/domain.list /home/user/wordlists/domains.txt"
#this if then uses if the variable is not a file it continues if it is it goes to else
elif [ ! -f "$domain_value" ]; then
	#Now the actual script starts
	#Making a directory for organization
	mkdir yssvirus_url-finder
	cd 'yssvirus_url-finder'
	echo 'Gathering results from subfinder'
	echo ''
	#here we start gathering subdomains
	puredns bruteforce $bruteforce_list $here --write puredns.log --resolvers-trusted resolvers.txt
	subfinder -dL puredns.log -all -active -o subfinder.log
	#Here is where we call our functions
	gau_func
	waybackurls_func
	here=$domain_value
	dome_func
	combine_logs
elif test -f "$domain_value"; then
	#Now the actual script starts
	#Making a directory for organization
	mkdir yssvirus_url-finder
	cd 'yssvirus_url-finder'
	echo 'Gathering results from subfinder'
	echo ''
	dnsvalidator -tL https://public-dns.info/nameservers.txt -timeout 7 -threads 20 -o resolvers.txt | sleep 300; killall dnsvalidator
	mkdir puredns
	while read -r here;
	do
		y=$(expr $x + 1)
		x=$y
		puredns bruteforce $bruteforce_list $here --write puredns/$x'puredns.log' --resolvers-trusted resolvers.txt
	done < $domain_value
	cat *puredns.log > puredns.log
	mv puredns/puredns.log puredns.log
	rm *puredns.log
	cd yssvirus_url-finder
	cat $domain_value >> puredns.log
	subfinder -dL puredns.log -all -active -o subfinder.log
	gau_func
	waybackurls_func
	while read -r here;
	do
		y=$(expr $x + 1)
		x=$y
		holder=$here # we need to store this value incase it doesnt srart with http or https
		#here we detect and strip hthe http and https parts
		clean=$(echo $here | grep "https://" | sed "s/"........"\(.*\)/\1/" | grep -v "http://" || grep http:// | sed "s/"......."\(.*\)/\1/" | grep -v "https:// ")
		here=clean # here it would assign blank value if it didnt start with http or https
		if [ -z "$here" ]; then # here we check if its blank if it is we do the next instruction
			here=$holder # remember when we had to store this this is why
		fi
		dome_func
	done < $domain_value
	combine_logs
fi
