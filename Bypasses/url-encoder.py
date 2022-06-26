#!/usr/bin/python3
import sys
from sys import stdin, stdout, argv
from pathlib import Path
import argparse
import urllib.request
import urllib.parse

def aggressive_url_encode(string):
    return "".join("%{0:0>2}".format(format(ord(char), "x")) for char in string)

unencoded = ''
all_chars = ''
parser = argparse.ArgumentParser(usage='python3 url-encoder.py -ac -L list.txt', description='This script is made for url encoding either key characters or all characters.')
encoding_parser = argparse.ArgumentParser()
encoding = parser.add_mutually_exclusive_group(required=True)
parser.add_argument('-l','-L','--l','--L', default='unencoded.txt', required=True, help='This is for defining the list of strings to encode')
encoding.add_argument('-kc','-KC','-kC','-Kc','--kc','--KC','--kC','--Kc', action='store_false', help='Use any of these to url encoding only KEY characters.')
encoding.add_argument('-ac','-AC','-aC','-Ac','--ac','--AC','--AC','--Ac', action='store_true', help='Use any of these to url encoding ALL characters')
encoding_args = encoding_parser.parse_args([])
args = parser.parse_args()

file = Path(args.l)
if file.exists():
	with open (file) as f:
		for line in f:
			if args.ac == True:
				url_encoded = aggressive_url_encode(line)
				line += ''
				stdout.write('The input ' + line + ' has been change to \n' + url_encoded)
				print('\n')
			else:
				url_encoded = urllib.parse.quote_plus(line)
				line += ''
				stdout.write('The input ' + line + ' has been change to \n' + url_encoded)
				print('\n')
else:
	print('File is not real please try again')
