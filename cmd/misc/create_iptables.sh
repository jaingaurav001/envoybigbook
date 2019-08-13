# Enable exit on non 0
set -e


iptables -t nat -N redirect-marked
iptables -A redirect-marked -t mangle -i eth1 -j MARK --set-mark 1
iptables -t nat -A redirect-marked --p tcp -m tcp --dport 80 -j REDIRECT --to-port 4999

sudo iptables -A POSTROUTING -t mangle --match mark --mark 0x0 -j mark-packets

sudo iptables -t mangle -N mark-packets

sudo iptables -t mangle -I POSTROUTING -p tcp -m tcp --dport 80 -d  172.31.24.143 -j MARK --set-mark 0x7


# Packet from inside container match this rule
sudo iptables -t mangle -I PREROUTING -p tcp -m tcp --dport 80 -d  172.31.24.143 -j MARK --set-mark 0x7
sudo iptables -t mangle -I PREROUTING -p tcp -m tcp --dport 80 -d  52.22.188.80 -j MARK --set-mark 0x7


sudo iptables -t mangle -I OUTPUT -p tcp -m tcp --dport 80 -d  172.31.24.143 --match mark --mark 0x7 -J ACCEPT
sudo iptables -t mangle -A OUTPUT -p tcp -m tcp --dport 80 -d  172.31.24.143 -j MARK --set-mark 0x7

sudo iptables -t nat -A OUTPUT --match mark --mark 0x7 -p tcp -m tcp --dport 80 -d  172.31.24.143 -j REDIRECT --to-port 4999


sudo iptables -t mangle -nvL PREROUTING

sudo iptables -t nat -A OUTPUT --match mark --mark 0x7 -p tcp -m tcp --dport 80 -d  172.31.24.143 -j ACCEPT




sudo iptables -t nat -A OUTPUT --match mark --mark 0x0 -p tcp -m tcp --dport 80 -d  172.31.24.143 -m owner ! --uid-owner 1001 -j REDIRECT --to-port 4999


sudo iptables -t nat -A OUTPUT --match mark --mark 0x0 -p tcp -m tcp --dport 80 -d  172.31.24.143 -m owner ! --uid-owner 0 -j REDIRECT --to-port 4999



sudo iptables -t nat -A OUTPUT --match mark --mark 0x0 -p tcp -m tcp --dport 80 -d  172.31.24.143 -j REDIRECT --to-port 4999


sudo iptables -t mangle -nvL POSTROUTING
sudo iptables -t nat -A OUTPUT --match mark --mark 0x0 -p tcp -m tcp --dport 80 -d  172.31.24.143 -j REDIRECT --to-port 4999
sudo iptables -t nat -A OUTPUT --match mark --mark 0x0 -p tcp -m tcp --dport 80 -d  172.31.24.143 -j REDIRECT --to-port 4999

sudo iptables -t nat -nvL OUTPUT


sudo iptables -t nat -A OUTPUT --match mark --mark 0x0 -p tcp -m tcp --dport 80 -d  151.101.189.67 -j REDIRECT --to-port 4999
sudo iptables -t nat -A OUTPUT --match mark --mark 0x7 -p tcp -m tcp --dport 80 -j REDIRECT --to-port 4999
sudo iptables -t nat -A OUTPUT -p tcp -m tcp --dport 443 -j REDIRECT --to-ports 8443


sudo iptables -A DOCKER-USER -p tcp -m tcp --dport 4999 -j MARK --set-mark 0x7

sudo iptables -A DOCKER-USER -p tcp -m tcp --dport 80 -j MARK --set-mark 0x7

sudo iptables -t filter -L --line-numbers


sudo iptables -t nat -L --line-numbers
#Chain PREROUTING (policy ACCEPT)
#num  target     prot opt source               destination
#1    DOCKER     all  --  anywhere             anywhere             ADDRTYPE match dst-type LOCAL
#
#Chain INPUT (policy ACCEPT)
#num  target     prot opt source               destination
#
#Chain OUTPUT (policy ACCEPT)
#num  target     prot opt source               destination
#1    DOCKER     all  --  anywhere            !localhost/8          ADDRTYPE match dst-type LOCAL
#2    REDIRECT   tcp  --  anywhere             anywhere             tcp dpt:http redir ports 4999
#
#Chain POSTROUTING (policy ACCEPT)
#num  target     prot opt source               destination
#1    MASQUERADE  all  --  ip-172-17-0-0.us-west-1.compute.internal/16  anywhere
#
#Chain DOCKER (2 references)
#num  target     prot opt source               destination
#1    RETURN     all  --  anywhere             anywhere

# Deleting
# sudo iptables -t nat -D OUTPUT 2