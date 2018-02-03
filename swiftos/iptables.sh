ip6tables -P INPUT DROP
ip6tables -P OUTPUT DROP

iptables -t mangle -F
iptables -F
iptables -t mangle -X
iptables -X

iptables -t mangle -A INPUT -i lo -j ACCEPT

#SSH
iptables -t mangle -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -t mangle -A OUTPUT -p tcp --sport 22 -m state --state ESTAB,REL -j ACCEPT

#Jenkins webapp
iptables -t mangle -A INPUT -p tcp --dport 8080 -j ACCEPT
iptables -t mangle -A OUTPUT -p tcp --sport 8080 -m state --state ESTAB,REL -j ACCEPT

iptables -t mangle -A INPUT -p icmp -j ACCEPT
iptables -t mangle -A OUTPUT -p icmp -m state --state ESTAB,REL -j ACCEPT

iptables -t mangle -A INPUT -j DROP
iptables -t mangle -A OUTPUT -j DROP

#sleep 5

#iptables -t mangle -F
#iptables -F
#iptables -t mangle -X
#iptables -X
