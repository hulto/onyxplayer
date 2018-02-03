mkdir -p $1 

echo "[+] Backing up Jenkins config files"
tar -czvf "$1/jenkins.tar.gz" /var/lib/jenkins/ /etc/init.d/jenkins /usr/share/jenkins/jenkins.war 1>/dev/null 2>"$1/../logs/jenkinsbackup_err.log" 
if [ ! -f "$1/jenkins.tar.gz" ]; then
        echo "[-] Can't make file \`$1/jenkins.tar.gz\`"
fi

echo "[+] Backing up ssh config files"
tar -czvf "$1/ssh.tar.gz" /etc/ssh/ 1>/dev/null 2>"$1/../logs/sshbackup_err.log"
if [ ! -f "$1/ssh.tar.gz" ]; then
        echo "[-] Can't make file \`$1/jenkins.tar.gz\`"
fi
if [ -d "/etc/httpd" ]; then
	echo "[+] Backing up httpd config files"
        tar -czvf "$1/httpd.tar.gz" /etc/httpd/ 1>/dev/null 2>"$1/../logs/httpdbackup_err.log"

	if [ ! -f "$1/httpd.tar.gz" ]; then
       		echo "[-] Can't make file \`$1/httpd.tar.gz\`"
	fi
fi
if [ -d "/etc/mysql" ]; then
	echo "[+] Backing up mysql config files"
        tar -czvf "$1/mysql.tar.gz" /etc/mysql/ 1>/dev/null 2>"$1/../logs/mysqlbackup_err.log"
	if [ ! -f "$1/mysql.tar.gz" ]; then
       		echo "[-] Can't make file \`$1/mysql.tar.gz\`"
	fi
fi
if [ -d "/etc/postgresql" ]; then
	echo "[+] backing up postgresql config files"
        tar -czvf "$1/postgresql.tar.gz" /etc/postgresql/ 1>/dev/null 2>"$1/../logs/postgresbackup_err.log"
	if [ ! -f "$1/postgresql.tar.gz" ]; then
       		echo "[-] Can't make file \`$1/postgresql.tar.gz\`"
	fi
fi
if [ -d "/etc/apache*" ]; then
	echo "[+] backing up apache config files"
        tar -czvf "$1/apache.tar.gz" /etc/apache* 1>/dev/null 2>"$1/../logs/apachebackup_err.log"
	if [ ! -f "$1/apache.tar.gz" ]; then
       		echo "[-] Can't make file \`$1/apache.tar.gz\`"
	fi
fi
if [ -d "/etc/tomcat*" ]; then
	echo "[+] backing up tomcat config files"
        tar -czvf "$1/tomcat.tar.gz" /etc/tomcat* 1>/dev/null 2>"$1/../logs/apachebackup_err.log"
	if [ ! -f "$1/tomcat.tar.gz" ]; then
       		echo "[-] Can't make file \`$1/tomcat.tar.gz\`"
	fi
fi
#backup - binaries No error handling just gonna let it go not that important plus really big
echo "[+] backing up binaries"
tar -czvf "$1/binary.tar.gz" $(echo $PATH | awk -F ':' '{$1=$1} 1') 1>/dev/null 2>"$1/../logs/binariesbackup_err.log" &

