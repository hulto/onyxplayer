mkdir -p /var/log/bak/configs
tar -czvf /var/log/bak/configs/jenkins.tar.gz /var/lib/jenkins/ /etc/init.d/jenkins /usr/share/jenkins/jenkins.war 
tar -czvf /var/log/bak/configs/ssh.tar.gz /etc/ssh/
