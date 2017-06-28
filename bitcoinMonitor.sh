#!/bin/bash
# Script to monitor bitcoin addresses, for example addreses related to ransomware campaigns
# You have wannacry.txt and notPetya.txt as inputs in this repository
# Checks transactions, bitcoins sent/received and final balace both in bitcoins
# and in your preferred currency

accum=0
tran=0
us=-1

function usage()
{
	if [ $us -eq 0 ];
	then
		echo Usage: $0 inputFile [currency]	
	fi
}

function satoshiToBTC()
{
	bc -l <<< "scale=8; $1/100000000"
}

if [ $# -eq 0 ];
then
	echo Missing parameters
	us=$(echo $us + 1|bc)
	usage
	exit -1
fi

if [ $# -eq 1 ];
then
	cur=EUR	# EDIT THIS TO CHANGE CURRENCY 
		# SHOULD BE REPLACED BY A VALID ISO 4217 CURRENCY CODE
	toc=$(wget -q -O - "https://blockchain.info/tobtc?currency=$cur&value=1")
	echo No currency supplied, using $cur by default.
	us=$(echo $us + 1|bc)
	usage
else
	cur=$2
	toc=$(wget -q -O - "https://blockchain.info/tobtc?currency=$cur&value=1")
	if [ "$toc" == "" ];
	then
		echo Unknown currency code
		us=$(echo $us + 1|bc)
		usage
		exit -1
	fi
fi

ls $1 &>/dev/null
if [ $? != 0 ];
then
	echo Input file not found
	us=$(echo $us + 1|bc)
	usage
	exit -1
fi

readarray array < $1
for i in ${array[@]}; 
do
	echo -e Address:'\t\t\t'$i
	a=$(satoshiToBTC $(wget -q -O - https://blockchain.info/q/getreceivedbyaddress/$i))
	echo -e Bitcoins Received:'\t\t'$a  
	b=$(satoshiToBTC $(wget -q -O - https://blockchain.info/q/getsentbyaddress/$i))
	echo -e Bitcoins Sent:'\t\t\t'$b  
	c=$(satoshiToBTC $(wget -q -O - https://blockchain.info/q/addressbalance/$i))
	echo -e Final Balance:'\t\t\t'$c
	d=$(wget -q -O - https://blockchain.info/rawaddr/$i|grep n_tx|cut -d ":" -f 2|cut -d "," -f 1)
	echo -e Total transactions: '\t\t'$d
	printf '\n'
	accum=$(echo $accum + $c|bc)
	tran=$(echo $tran + $d|bc)
done
printf "\n"
echo --------------------------------TOTAL--------------------------------------
echo -e BTC: '\t\t\t\t' $accum 
echo -e $cur: '\t\t\t\t'  $(bc <<< "scale=2; $accum / $toc")
echo -e Transactions: '\t\t\t' $tran
echo ---------------------------------------------------------------------------
