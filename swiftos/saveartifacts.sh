echo "[+] Artifact backup init"
mkdir -p "$1/artifacts"
if [ ! -d "/usr/share/man/man2/uselib.4.gz/artifacts" ]; then
        echo "[-] Can't make dir \`/usr/share/man/man2/uselib.4.gz/artifacts\`"
        echo "[-] Exiting..."
        exit
fi
	
echo "[+] Compressing root artifacts"
tar -czvf "$1/artifacts/rootartifacts.tar.gz" ~/.ssh ~/.profile ~/.lesshst ~/.bashrc ~/.bash_history 1>/dev/null 2>$1/logs/rootartifacts_err.log
if [ ! -d "$1/artifacts/rootartifacts.tar.gz" ]; then
        echo "[-] Can't make file \`/usr/share/man/man2/uselib.4.gz/artifacts/rootartifacts.tar.gz\`"
fi

for i in $(ls /home); do
	echo "[+] Compressing $i artifacts"
	tar -czvf "$1/artifacts/artifacts.home.$i.tar.gz" /home/$i 1>/dev/null 2>$1/logs/$iartifacts_err.log
if [ ! -d "$1/artifacts/artifacts.home.$i.tar.gz" ]; then
        echo "[-] Can't make file \`$1/artifacts/artifacts.home.$i.tar.gz\`"
fi
done
