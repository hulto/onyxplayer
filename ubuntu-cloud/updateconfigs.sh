mkdir /var/log/bak
cp /etc/ssh/sshd_config /var/log/bak/sshd_config.bak
cp /etc/sudoers /var/log/bak/sudoers.bak

cat sshd_config > /etc/ssh/sshd_config
cat sudoers > /etc/sudoers 

/etc/init.d/sshd restart
