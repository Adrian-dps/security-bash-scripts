#!/bin/bash
# Script that uses netdiscover -r $firstArg and output only the ip addresses
# You can use this output for example to use as input list (-iL) for nmap 
sudo netdiscover -P -r $1|grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"

