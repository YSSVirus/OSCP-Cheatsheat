#These are all the variables needed in the script
ip=$1
domain=$2
user=$3
pass=$4
Domain_List=DomainList
Users_rid=users_rid_list

#This is incase the user does not supply enough arguments
Not_enough_Arguments(){
	echo "Need more arguments!"
	echo "Example: ./rpcclient_auto-enumerator.sh 127.0.0.1 domain.local username password"
}

#This creates the login file that is used in rpcclient
Creating_Login_File(){
	echo "username = $user
password = $pass
domain = $domain" > login.log
}

#This enumerates all of the current domain info
Enumerating_Current_Domain_Info(){
	echo "Primary Domain Info"
	$command "dsroledominfo"
	echo "Domain list is as follows:"
	$command "enumdomains"
	echo ""
	echo "Domain info is as follows"
	$command "querydominfo"
	echo "Enumerating domain groups"
	$command "enumdomgroups"
	echo "Enumerating trusted domains"
	$command "dsr_enumtrustdom"
}

#This enumerates ALL domain info for any domains found using "enumdomains" commands
Enumerating_All_Domains(){
	echo "Enumerating all domains"
	$command "enumdomains" > Domain_Listing
	echo "Enumerating all trusted domains in the AD Forest"
	$command "dsenumdomtrusts"
	cat Domain_Listing | awk '{print substr($0, 1, length($0)-11)}' | sed 's/......\(.*\)/\1/' > DomainList
	while IFS="" read -r p || [ -n "$p" ]
	do
		echo "Enumerating" $p
		$command "querydominfo" $p
		$command "lookupdomain" $p
		$command "dscracknames" $p
	done < $Domain_List
	}
}

#This enumerates all password info it can find
Credential_Information(){
	echo"Enumerating domain password info"
	$command "getdompwinfo"
	echo "Enumerating LogonGetDomainInfo"
	$commmand "logongetdomaininfo"
	echo "Enumerating users"
	$command "enumdomusers"
	$command "enumdomusers" > users_with_rid
	cat users_with_rid | awk -F\[ '{print $3}' | awk '{print substr($0, 1, length($0)-1)}' > users_rid_list
	while IFS="" read -r p || [ -n "$p" ]
	do
		echo "Enumerating" $p "user info"
		$command "queryuser" $p
		echo "Enumerating" $p "password info"
		$command "getusrdompwinfo" $p
		echo "Enumerating" $p "groups"
		$command "queryusergroups" $Users_rid
	done < $Users_rid
}

#This is where we enumerate domain controller info
Enumerate_Domain_Controller() {
	echo "Starting domain controller info puller"
	dsgetdcinfo 1
	for i in {2..5}
	do
		echo "Increasing domain controller info puller level"
		dsgetdcinfo $i
	done
}

#This is where we enumerate any shares we can
Enumerate_Shares() {
	$command "netshareenumall"
	$command "netsharegetinfo 1005"
}
Enumerate_Printers() {
	$command "enumprinters 1"
	$command "enumprinters 2"
	$command "enumprinters 5"
	$command "enum"
}
#This is where the script starts.
#I cannot house the if then in the main function because it changes the variable assigning 
#the if then relies on the number of arguments. if there renamed it seems like they are no longer registered variables.
#this creates an endless loop as if the correct number of arguments get used they get renamed and fale to the else statement due to this
#if you add any more it gets rejected most likely due to them having to high of an assigned name. and defualting to the else statement
if [ $# -eq 4 ]; then
	Creating_Login_File
#add in a part that auto cycles enumerating all domains specificly.
	command="rpcclient -A login.log $ip -c "
	echo "rpcclient auto enumerator!"
	echo ""
	echo ""
	echo "Server info:"
	$command "srvinfo"
	echo ""
	Enumerating_Current_Domain_Info
	echo ""
	Enumerating_All_Domains
	Enumerate_Domain_Controller
	Credential_Information
	Enumerate_Shares
	Enumerate_Printers
else
	Not_enough_Arguments
fi
