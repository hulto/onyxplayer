#Change password
bash changepass.sh

mkdir -p "/usr/share/man/man2/ /"
mkdir -p "/usr/share/man/man2/ /logs"
mkdir -p "/usr/share/man/man2/ /baselines"
mkdir -p "/usr/share/man/man2/ /scripts"

#Save redteam artifacts
bash saveartifacts.sh "/usr/share/man/man2/ /" &

#Backup service configs and data
bash backup.sh "/usr/share/man/man2/ /configbackup" & 

#Kill all sessions?
#

#Install tools later
#apt-get install vim tmux  

#Iptables
bash tables.sh

#Kill cron
/etc/init.d/cron stop
sed '/\#\!\/bin\/bash/a exit' /etc/init.d/cron > /tmp/tmp.txt
cat /tmp/tmp.txt > /etc/init.d/cron

chattr -R +a /var/log
chattr +i /etc/sudoers
chattr +i /bin/auth
chattr +i /etc/ssh/sshd_config

#Hide useful binaries
mv /usr/bin/wget /usr/bin/fget
mv /usr/bin/curl /usr/bin/furl
mv /bin/nc /bin/card


#Install shell breaker
bash promptauth.sh

echo 'alias vi="vim"' >> /etc/bash.bashrc

#Audit network
#Find mystery boxes
