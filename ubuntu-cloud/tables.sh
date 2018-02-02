# Ubuntu Cloud
# ICMP
# SSH server: tcp:22 in
# HTTP server: tcp:80 in

iptables -t mangle -F
iptables -t mangle -X

# Remote
iptables -t mangle -P INPUT ACCEPT
iptables -t mangle -P OUTPUT ACCEPT

# Allow established and related outbound traffic
iptables -t mangle -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow ICMP request in
iptables -t mangle -A INPUT -p ICMP --icmp-type echo-request -j ACCEPT
iptables -t mangle -A OUTPUT -p ICMP --icmp-type echo-reply -j ACCEPT

# SSH server
iptables -t mangle -A INPUT -p TCP --dport 22 -j ACCEPT

# HTTP Server
iptables -t mangle -A INPUT -p TCP --dport 80 -j ACCEPT

# DROP everything else
iptables -t mangle -A INPUT -j DROP
iptables -t mangle -A OUTPUT -j DROP

# Uncomment for testing
sleep 100
iptables -t mangle -F
