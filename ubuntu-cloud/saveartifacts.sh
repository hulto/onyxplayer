mkdir -p "$1/artifacts"
tar -czvf "$1/artifacts/rootartifacts.tar.gz" ~/.ssh ~/.profile ~/.lesshst ~/.bashrc ~/.bash_history
for i in $(ls /home); do
	tar -czvf "$1/artifacts/artifacts.home.$i.tar.gz" /home/$i
done
