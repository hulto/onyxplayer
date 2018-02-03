# ParrotOS
# ICMP
# SSH server: tcp:22 in

iptables -t mangle -F
iptables -t mangle -X

# Local
iptables -t mangle -P INPUT DROP
iptables -t mangle -P OUTPUT DROP

# Allow established and related outbound traffic
iptables -t mangle -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow ICMP request in
iptables -t mangle -A INPUT -p ICMP --icmp-type echo-request -j ACCEPT
iptables -t mangle -A OUTPUT -p ICMP --icmp-type echo-reply -j ACCEPT

# SSH server
iptables -t mangle -A INPUT -p TCP --dport 22 -j ACCEPT

# that thing
iptables -t mangle -A OUTPUT -p TCP --dport 22 -j ACCEPT
iptables -t mangle -A INPUT -p TCP --sport 22 -j ACCEPT

iptables -t mangle -A OUTPUT -p TCP --dport 80 -j ACCEPT
iptables -t mangle -A INPUT -p TCP --sport 80 -j ACCEPT

iptables -t mangle -A OUTPUT -p TCP --dport 443 -j ACCEPT
iptables -t mangle -A INPUT -p TCP --sport 443 -j ACCEPT

iptables -t mangle -A INPUT -i lo -j ACCEPT
iptables -t mangle -A OUTPUT -o lo -j ACCEPT

# Uncomment for testing
# sleep 10
# iptables -t mangle -F
