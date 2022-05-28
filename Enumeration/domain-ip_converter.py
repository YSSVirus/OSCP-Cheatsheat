#!/usr/bin/python3
#importing
from pathlib import Path
import sys
import socket

#variables
domain = sys.argv[1]
file = Path(domain)

#print(socket.gethostbyname(domainName))
if file.exists():
    #print('file')
    with open(file) as f:
    	for line in f:
            domain_stripped = line.strip()
            utf8_domain = domain_stripped.encode('UTF-8')
            try:
                print(socket.gethostbyname(utf8_domain))
            except socket.gaierror:
                print('Error: The domain', utf8_domain, 'does not seem to have an ip attatched')
else:
    utf8_domain = domain.encode('UTF-8')
    try:
        print(socket.gethostbyname(utf8_domain))
    except socket.gaierror:
        print('Error: The domain', utf8_domain, 'does not seem to have an ip attatched')
