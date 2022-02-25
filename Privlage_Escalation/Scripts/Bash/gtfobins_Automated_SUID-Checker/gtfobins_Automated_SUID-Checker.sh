#! /bin/bash
clear
program_name_list=$1
Main_Function(){
        while IFS="" read -r p || [ -n "$p" ]
        do
            curl --connect-timeout 2 'https://gtfobins.github.io/gtfobins/'$p'/#suid' | grep 'SUID' && echo $p' has a SUID entry on gtfobins here is the link https://gtfobins.github.io/gtfobins/'$p'/#suid'
        done < $program_name_list
    }
Main_Function                                                                                                                                                                                            
