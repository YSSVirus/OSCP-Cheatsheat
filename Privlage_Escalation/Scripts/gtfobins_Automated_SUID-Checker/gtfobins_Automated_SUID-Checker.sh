#! /bin/bash
clear
program_name=$1
Main_Function(){
        while IFS="" read -r p || [ -n "$p" ]
        do
                bash $(pwd)'/gtfobins_Single_SUID-Checker.sh' $p
        done < $program_name
}
Question(){
        echo 'Do you have the gtfobins_Single_SUID-Checker.sh script? (make sure you launch this script from the same folder as the previously mentioned script.)'
        read Dependencie_Answer
}
Question
if [[ $Dependencie_Answer == yes ]] || [[ $Dependencie_Answer == yes ]] || [[ $Dependencie_Answer == Y ]] || [[ $Dependencie_Answer == y ]]; then
        Main_Function
elif [[ $Dependencie_Answer == No ]] || [[ $Dependencie_Answer == no ]] || [[ $Dependencie_Answer == N ]] || [[ $Dependencie_Answer == n ]]; then
        script_url=
    wget script_url
    Main_Function
else
        Question
fi 
