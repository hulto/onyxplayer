tar -czvf /var/log/bak/artifacts.tar.gz ~/.ssh ~/.profile ~/.lesshst ~/.bashrc ~/.bash_history
for i in $(ls /home); do
	tar -czvf /var/log/bak/artifacts.home.$i.tar.gz /home/$i
done
