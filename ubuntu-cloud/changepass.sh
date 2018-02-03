NEWPASS='K1ttyCAtz##))'

for i in $(cat /etc/shadow); do
	for j in $(echo $i | awk -F ':' '{
				if ($2 != "*")
					print $1

			}'); do
		echo "$j:$NEWPASS" | chpasswd
	done
done

if [ -d "/etc/mysql" ]; then
	echo "[+] Changing mysql root password"
	mysql --user='root' --password='password' --database='mysql' --execute="UPDATE user SET password=PASSWORD('HoneyD3w15Delicious:)') WHERE user='root';FLUSH PRIVILEGES;"
	/etc/init.d/mysql stop
	/etc/init.d/mysql start
fi
