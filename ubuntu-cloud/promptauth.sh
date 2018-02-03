cat auth > /bin/auth
chmod 711 /bin/auth

echo "export PROMPT_COMMAND='/bin/auth'" >> /etc/bash.bashrc

