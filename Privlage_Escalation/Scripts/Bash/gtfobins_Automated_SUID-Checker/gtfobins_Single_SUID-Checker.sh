#!/bin/bash
program_name=$1; curl --connect-timeout 2 'https://gtfobins.github.io/gtfobins/'$program_name'/#suid' | grep 'SUID' && echo $program_name' has a SUID entry on gtfobins here is the link https://gtfobins.github.io/gtfobins/'$program_name'/#suid'
