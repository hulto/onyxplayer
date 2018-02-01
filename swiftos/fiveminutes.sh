#Change password
#echo "root:password"
#bash changepass.sh
#bash iptables.sh

#Backup artifacts
#.bashhistory
#.viminfo
#.recently modified files
bo

#Kill cron
/etc/init.d/cron stop
sed '/\#\!\/bin\/bash/a exit' /etc/init.d/cron > /tmp/tmp.txt
cat /tmp/tmp.txt > /etc/init.d/cron

#Install OSQuery

chattr -R +a /var/log
chattr +i /etc/sudoers
chattr +i /bin/auth
chattr +i /etc/ssh/sshd_config

#Hide useful binaries
mv /usr/bin/wget /usr/bin/fget
mv /usr/bin/curl /usr/bin/furl
mv /bin/nc /bin/card


echo 'alias vi="vim"' >> /etc/bash.bashrc
