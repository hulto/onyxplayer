mkdir -p $1 

#touch "$1/test"

#exit
echo "[+] Backing up Jenkins config files"
#tar -czvf "$1/jenkins.tar.gz" /var/lib/jenkins/ /etc/init.d/jenkins /usr/share/jenkins/jenkins.war 


tar -czvf "$1/webcontent.tar.gz" /var/www
tar -czvf "$1/ssh.tar.gz" /etc/ssh/
if [ -d "/etc/httpd" ]; then
	tar -czvf "$1/httpd.tar.gz" /etc/httpd/
fi
if [ -d "/etc/mysql" ]; then
	tar -czvf "$1/mysql.tar.gz" /etc/mysql/
fi
if [ -d "/etc/postgresql" ]; then
	tar -czvf "$1/postgresql.tar.gz" /etc/postgresql/
fi
if [ -d "/etc/apache*" ]; then
	tar -czvf "$1/apache.tar.gz" /etc/apache*
fi
if [ -d "/etc/tomcat*" ]; then
	tar -czvf "$1/tomcat.tar.gz" /etc/tomcat*
fi
#backup - binaries
tar -czvf $(echo $PATH | awk -F ':' '{$1=$1} 1')
