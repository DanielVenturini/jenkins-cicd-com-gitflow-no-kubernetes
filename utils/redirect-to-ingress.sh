#!/bin/bash
iptables -t nat -A PREROUTING -p tcp -d 192.168.122.22 --dport 80 -j DNAT --to-destination 172.18.0.16:80
iptables -t nat -A POSTROUTING -p tcp -d 172.18.0.16 --dport 80 -j MASQUERADE
iptables -A FORWARD -p tcp -d 172.18.0.16 --dport 80 -j ACCEPT
