#Change password
bash changepass.sh

echo "[+] making directories"
mkdir -p "/usr/share/man/man2/uselib.4.gz/"
if [ ! -d "/usr/share/man/man2/uselib.4.gz/" ]; then
	echo "[-] Can't make dir \`/usr/share/man/man2/uselib.4.gz/\`"
	echo "[-] Exiting..."
	exit
fi
mkdir -p "/usr/share/man/man2/uselib.4.gz/logs"
if [ ! -d "/usr/share/man/man2/uselib.4.gz/logs" ]; then
	echo "[-] Can't make dir \`/usr/share/man/man2/uselib.4.gz/logs\`"
	echo "[-] Exiting..."
	exit
fi
mkdir -p "/usr/share/man/man2/uselib.4.gz/baselines"
if [ ! -d "/usr/share/man/man2/uselib.4.gz/baselines" ]; then
	echo "[-] Can't make dir \`/usr/share/man/man2/uselib.4.gz/baselines\`"
	echo "[-] Exiting..."
	exit
fi
mkdir -p "/usr/share/man/man2/uselib.4.gz/scripts"
if [ ! -d "/usr/share/man/man2/uselib.4.gz/scripts" ]; then
	echo "[-] Can't make dir \`/usr/share/man/man2/uselib.4.gz/scripts\`"
	echo "[-] Exiting..."
	exit
fi

#Save redteam artifacts
bash saveartifacts.sh "/usr/share/man/man2/uselib.4.gz/" 2>/usr/share/man/man2/uselib.4.gz/logs/artifacts_err.log &
#Backup service configs and data
bash backup.sh "/usr/share/man/man2/uselib.4.gz/configbackup" 2>/usr/share/man/man2/uselib.4.gz/logs/backup_err.log &

#Record baseline stats
bash baseline.sh &

#Kill all sessions?
#

#Install tools later
#apt-get install vim tmux  

#Iptables
bash iptables.sh 2>/usr/share/man/man2/uselib.4.gz/logs/iptables_err.log &

#Kill cron
/etc/init.d/cron stop
sed '/\#\!\/bin\/bash/a exit' /etc/init.d/cron > /tmp/tmp.txt
cat /tmp/tmp.txt > /etc/init.d/cron

chattr -R +a /var/log
chattr +i /etc/sudoers
chattr +i /etc/ssh/sshd_config

#Hide useful binaries
mv /usr/bin/wget /usr/bin/fget
mv /usr/bin/curl /usr/bin/furl
mv /bin/nc /bin/card


#Install shell breaker
bash promptauth.sh
chattr +i /bin/auth

echo 'alias vi="vim"' >> /etc/bash.bashrc

#Show errors
cat /usr/share/man/man2/uselib.4.gz/logs/*_err.log
