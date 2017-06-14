#!/bin/bash
# Script to monitor all known bitcoin addresses related to wannacry ramsonware
# Checks transaction, bitcoins sent/received and final balace both in bitcoins
# and in your preferred currecy

if [ $# -eq 0 ];
then
	cur=EUR	# EDIT THIS TO CHANGE CURRENCY 
		# SHOULD BE REPLACED BY A VALID ISO 4217 CURRENCY CODE
	echo No currency supplied, using $cur by default.
	echo Usage: $0 [currency]
else
	cur=$1
fi
dir1=13AM4VW2dhxYgXeQepoHkHSQuy6NgaEb94
dir2=12t9YDPgwueZ9NyMgw519p7AA8isjr6SMw
dir3=115p7UMMngoj1pMvkpHijcRdfJNXj6LrLn
accum=0
tran=0

function satoshiToBTC(){
	bc -l <<< "scale=8; $1/100000000"
}
for i in $dir1 $dir2 $dir3; do
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
toc=$(wget -q -O - "https://blockchain.info/tobtc?currency=$cur&value=1")
echo -e BTC: '\t\t\t\t' $accum 
echo -e $cur: '\t\t\t\t'  $(bc <<< "scale=2; $accum / $toc")
echo -e Transactions: '\t\t\t' $tran
echo ---------------------------------------------------------------------------
