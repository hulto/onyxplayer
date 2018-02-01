NEWPASS='newpass'

for i in $(cat /etc/shadow); do
	for j in $(echo $i | awk -F ':' '{
				if ($2 != "*")
					print $1

			}'); do
		echo "$j:$NEWPASS" | chpasswd
	done
done
