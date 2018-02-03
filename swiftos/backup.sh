mkdir -p $1 

#touch "$1/test"

#exit
echo "[+] Backing up Jenkins config files"
tar -czvf "$1/jenkins.tar.gz" /var/lib/jenkins/ /etc/init.d/jenkins /usr/share/jenkins/jenkins.war 
tar -czvf "$1/ssh.tar.gz" /etc/ssh/


#backup - binaries
