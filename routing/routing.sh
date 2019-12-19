#!/bin/bash

. /etc/routing/vars.sh

for i in /proc/sys/net/ipv4/conf/*/rp_filter; do
        echo 0 > $i
done


#Routing rules
ip route flush table $ISP1_TB
ip route flush table $ISP2_TB
#ip route flush table $VPN0_TB

ip route add $ISP1_NET dev $ISP1_IF src $ISP1_IP table $ISP1_TB
ip route add $ISP2_NET dev $ISP2_IF table $ISP1_TB
#ip route add $LOCAL_NET dev $LOCAL_IF table $ISP1_TB
ip route add 127.0.0.0/8 dev lo table $ISP1_TB
ip route add default via $ISP1_GW table $ISP1_TB
ip route add $TEST1 via $ISP1_GW table $ISP1_TB
ip route add $TEST2 via $ISP2_GW table $ISP1_TB

ip route add $ISP1_NET dev $ISP1_IF table $ISP2_TB
ip route add $ISP2_NET dev $ISP2_IF src $ISP2_IP table $ISP2_TB
#ip route add $LOCAL_NET dev $LOCAL_IF table $ISP2_TB
ip route add 127.0.0.0/8 dev lo table $ISP2_TB
ip route add default via $ISP2_GW table $ISP2_TB
ip route add $TEST1 via $ISP1_GW table $ISP2_TB
ip route add $TEST2 via $ISP2_GW table $ISP2_TB



#ip route add $VPN0_NET dev $VPN0_IF table $VPN0_TB
#ip route add $VPN0_NET dev $VPN0_IF src $VPN0_IP table $VPN0_TB
#ip route add $LOCAL_NET dev $LOCAL_IF table $ISP2_TB
#ip route add 127.0.0.0/8 dev lo table $VPN0_TB
#ip route add default via $VPN0_IP table $VPN0_TB


ip route del default

ip route add default via $DGW

#ip route add default scope global nexthop via $ISP1_IP dev $ISP1_IF weight 3 nexthop via $ISP2_IP dev $ISP2_IF weight 7

ip rule del table $ISP1_TB
#ip rule del table $ISP1_TB
ip rule del table $ISP2_TB
#ip rule del table $ISP2_TB
#ip rule del table $VPN0_TB
ip rule del table $VPN6_TB

ip rule add from $ISP1_IP table $ISP1_TB
ip rule add from $ISP2_IP table $ISP2_TB
#ip rule add from $VPN0_IP table $VPN0_TB

ip rule add fwmark $ISP1_MK table $ISP1_TB
ip rule add fwmark $ISP2_MK table $ISP2_TB
ip rule add fwmark $VPN0_MK table $VPN0_TB
ip rule add fwmark $VPN6_MK table $VPN6_TB

ip route flush cache
##############


#iptables
$IPT -t nat -F
$IPT -t filter -F
$IPT -t mangle -F

$IPT -P INPUT ACCEPT
$IPT -P OUTPUT ACCEPT
$IPT -P FORWARD ACCEPT

#$IPT -A INPUT -i tap0 -j ACCEPT
#$IPT -A INPUT -i br0 -j ACCEPT
#$IPT -A FORWARD -i br0 -j ACCEPT


#$IPT -A INPUT -i tun0 -j ACCEPT
#$IPT -A OUTPUT -i tun0 -j ACCEPT
#$IPT -A FORWARD -i tun0 -j ACCEPT


#$IPT -t filter -I INPUT -i $VPN0_IF -j ACCEPT
#$IPT -t filter -I FORWARD -i $VPN0_IF -j ACCEPT
#$IPT -t filter -I OUTPUT -o $VPN0_IF -j ACCEPT
#$IPT -t filter -I FORWARD -o $VPN0_IF -j ACCEPT

#iptables mangle
echo $DMK
$IPT -t mangle -A PREROUTING -s $LOCAL_NET -j MARK --set-mark $DMK
#for (( IP=1 ; IP <= 254; IP++ )); do
#	$IPT -t mangle -A PREROUTING -s 192.168.99.$IP -j MARK --set-mark $ISP2_MK
#done
$IPT -t mangle -A PREROUTING -s 192.168.99.0/24 -j MARK --set-mark $ISP2_MK
#for (( IP=1 ; IP <= 254; IP++ )); do
#        $IPT -t mangle -A PREROUTING -s $LOCAL_LAN.$IP -j MARK --set-mark $DMK
#done

#$IPT -t mangle -A PREROUTING -s $VPN0_RDP -j MARK --set-mark $VPN0_MK
#$IPT -t mangle -A PREROUTING -i $VPN0_IF -p tcp --dport 3389 -j MARK --set-mark $VPN0_MK

for IP in $ISP1_ONLY; do
#        $IPT -t mangle -D PREROUTING -s $LOCAL_LAN.$IP -j MARK --set-mark $DMK
        $IPT -t mangle -A PREROUTING -s $LOCAL_LAN.$IP -j MARK --set-mark $ISP1_MK
done
for IP in $ISP2_ONLY; do
#        $IPT -t mangle -D PREROUTING -s $LOCAL_LAN.$IP -j MARK --set-mark $DMK
        $IPT -t mangle -A PREROUTING -s $LOCAL_LAN.$IP -j MARK --set-mark $ISP2_MK
done

#$IPT -t mangle -A PREROUTING -s 192.168.99.70 -j MARK --set-mark $ISP2_MK

#for (( IP=1 ; IP <= 254; IP++ )); do
#	$IPT -t mangle -A PREROUTING -s 192.168.99.$IP -j MARK --set-mark $ISP2_MK
#done
for IP in $VPN0_MK1; do
#	$IPT -t mangle -A PREROUTING -i eth0 -p tcp --dport 25 -j MARK --set-mark 1
	$IPT -t mangle -A PREROUTING -s $LOCAL_LAN.$IP -j MARK --set-mark $VPN0_MK
done
################

#5938 - Teamviewer
#MAIL_PORTS='25 110 143 465 993 995 5938'
#for MAIL_PORT in $MAIL_PORTS; do
#	$IPT -t mangle -A PREROUTING -s $LOCAL_LAN.'0/24' -p tcp --dport $MAIL_PORT -j MARK --set-mark $ISP2_MK
#	$IPT -t mangle -A PREROUTING -s $LOCAL_LAN.'0/24' -p udp --dport $MAIL_PORT -j MARK --set-mark $ISP2_MK
#done

#$IPT -t mangle -A PREROUTING -s 192.168.97.11 -j MARK --set-mark $ISP2_MK
#$IPT -t mangle -A PREROUTING -s 192.168.98.111 -j MARK --set-mark $ISP2_MK

#$IPT -t mangle -A PREROUTING -s $VPN0_RDP -j MARK --set-mark $VPN0_MK

#$IPT -t mangle -D PREROUTING -s $VPN0_RDP -p tcp --dport 3389 -j MARK --set-mark $ISP2_MK
#$IPT -t mangle -A PREROUTING -s $VPN0_RDP -p tcp --dport 3389 -j MARK --set-mark $VPN0_MK

$IPT -t mangle -A PREROUTING -s $VPN0_RDP -j MARK --set-mark $VPN0_MK
$IPT -t mangle -A PREROUTING -s $VPN0_RDP2 -j MARK --set-mark $VPN0_MK
$IPT -t mangle -A PREROUTING -s $VPN4_USER1 -j MARK --set-mark $VPN4_MK
#$IPT -t mangle -A PREROUTING -i $VPN0_IF -p tcp --dport 3389 --destination 192.168.98.11 -j MARK --set-mark $VPN0_MK

#iptables -t mangle -A PREROUTING --destination 192.168.98.11 -j MARK --set-mark $VPN0_MK
#iptables -t nat -A PREROUTING -m mark --mark $VPN0_MK -i $VPN0_IF -j DNAT --to 11.1.1.1
#iptables -t nat -A POSTROUTING -m mark --mark $VPN0_MK -o $VPN0_IF -j SNAT --to-source 11.1.1.1

$IPT -t mangle -A PREROUTING -s $VPN2_RDP -j MARK --set-mark $VPN2_MK
$IPT -t mangle -A PREROUTING -s $VPN2_RDP2 -j MARK --set-mark $VPN2_MK
$IPT -t mangle -A PREROUTING -s $VPN3_RDP -j MARK --set-mark $VPN3_MK
$IPT -t mangle -A PREROUTING -s $VPN4_SERVER -j MARK --set-mark $VPN4_MK
#$IPT -t mangle -A PREROUTING -s $VPN6_RDP1 -j MARK --set-mark $VPN6_MK

### ROUTING POLICY FOR VPN networks ###
for IP in $VPN1_RESOURCE; do
	$IPT -t mangle -A PREROUTING -s $IP -j MARK --set-mark $VPN1_MK
done


### Ports forwarding for admin vpn ###
$IPT -t nat -A PREROUTING -i $VPN1_IF -p tcp -m tcp --dport 11 -j DNAT --to-destination 192.168.98.11:3389
$IPT -t nat -A PREROUTING -i $VPN1_IF -p tcp -m tcp --dport 101 -j DNAT --to-destination 192.168.98.1:3389
$IPT -t nat -A PREROUTING -i $VPN1_IF -p tcp -m tcp --dport 102 -j DNAT --to-destination 192.168.98.2:3389
$IPT -t nat -A PREROUTING -i $VPN1_IF -p tcp -m tcp --dport 107 -j DNAT --to-destination 192.168.98.7:22
$IPT -t nat -A PREROUTING -i $VPN1_IF -p tcp -m tcp --dport 104 -j DNAT --to-destination 192.168.99.71:22
$IPT -t nat -A PREROUTING -i $VPN1_IF -p tcp -m tcp --dport 5900 -j DNAT --to-destination 192.168.99.71:5900
$IPT -t nat -A PREROUTING -i $VPN1_IF -p tcp -m tcp --dport 5901 -j DNAT --to-destination 192.168.99.71:5901
$IPT -t nat -A PREROUTING -i $VPN1_IF -p tcp -m tcp --dport 5902 -j DNAT --to-destination 192.168.99.71:5902
$IPT -t nat -A PREROUTING -i $VPN1_IF -p tcp -m tcp --dport 105 -j DNAT --to-destination 192.168.99.72:22
$IPT -t nat -A PREROUTING -i $VPN1_IF -p tcp -m tcp --dport 1050 -j DNAT --to-destination 192.168.99.72:10000
$IPT -t nat -A PREROUTING -i $VPN1_IF -p tcp -m tcp --dport 6900 -j DNAT --to-destination 192.168.99.72:5900
$IPT -t nat -A PREROUTING -i $VPN1_IF -p tcp -m tcp --dport 6901 -j DNAT --to-destination 192.168.99.72:5901
$IPT -t nat -A PREROUTING -i $VPN1_IF -p tcp -m tcp --dport 6902 -j DNAT --to-destination 192.168.99.72:5902
$IPT -t nat -A PREROUTING -i $VPN1_IF -p tcp -m tcp --dport 80 -j DNAT --to-destination 192.168.98.7:80
$IPT -t nat -A PREROUTING -i $VPN1_IF -p tcp -m tcp --dport 3389 -j DNAT --to-destination 192.168.98.111:3389
$IPT -t nat -A PREROUTING -i $VPN1_IF -p tcp -m tcp --dport 1000 -j DNAT --to-destination 192.168.99.100:80
$IPT -t nat -A PREROUTING -i $VPN1_IF -p tcp -m tcp --dport 81 -j DNAT --to-destination 192.168.98.11:80
#######################################


#$IPT -t nat -A POSTROUTING -m mark --mark $VPN0_MK -j SNAT --to-source $VPN0_IP
#$IPT -t nat -A POSTROUTING -i $VPN1_IF -m mark --mark $VPN1_MK -j SNAT --to-source $VPN1_IP
#nat

### Squid ###

#for (( IP=1 ; IP <= 254; IP++ )); do
#$IPT -t nat -A PREROUTING -p tcp -m multiport --dports 80,8080 -s $LAN.$IP -j REDIRECT --to-port 3128
#done


#$IPT -t nat -A PREROUTING -p tcp -m multiport --dports 80,8080 -s $LOCAL_NET -j REDIRECT --to-port 3128

#for IP in $NOSQUID; do
#$IPT -t nat -D PREROUTING -p tcp -m multiport --dports 80,8080 -s $LOCAL_LAN.$IP -j REDIRECT --to-port 3128
#done
#$IPT -t nat -A PREROUTING -p tcp -m multiport --dports 80,8080 -s $LOCAL_NET -j REDIRECT --to-port 3128

#for IP in $NOSQUID; do
#$IPT -t nat -A PREROUTING -p tcp -m tcp --dports 8080 -s $LOCAL_LAN.$IP -j REDIRECT --to-port 80
#$IPT -t nat -A PREROUTING -p tcp -m multiport --dports 8080 -s $LOCAL_LAN.$IP -j REDIRECT --to-port 8080
#done

#-------------------------------------------------------------------------------------------------------------------


#Port forwarding


### 
#$IPT -t nat -A PREROUTING -i $ISP1_IF -p tcp -m tcp --dport 55555 -j DNAT --to-destination $VPN0_RDP:3389
$IPT -t nat -A PREROUTING -i $ISP1_IF -p tcp -m tcp --dport 22222 -j DNAT --to-destination $VPN2_RDP:3389


#$IPT -t nat -A PREROUTING -i $VPN0_IF -p tcp -m tcp --dport 3389 -j DNAT --to-destination $VPN0_RDP:3389
$IPT -t nat -A PREROUTING -i $VPN0_IF -p tcp -m tcp --dport 80 -j DNAT --to-destination $VPN0_RDP:80
#$IPT -t nat -A PREROUTING -i $VPN0_IF -p tcp -m tcp --dport 3389 -j DNAT --to-destination $VPN0_RDP2:3389
$IPT -t nat -A PREROUTING -i $VPN0_IF -p tcp -m tcp -s $VPN0_CLIENT2 --dport 3389 -j DNAT --to-destination $VPN0_RDP2:3389
$IPT -t nat -A PREROUTING -i $VPN0_IF -p tcp -m tcp -s 10.1.1.10/32 --dport 3389 -j DNAT --to-destination $VPN0_RDP2:3389

$IPT -t nat -A PREROUTING -i $VPN0_IF -p tcp -m tcp -s $VPN0_CLIENT2 --dport 3388 -j DNAT --to-destination 192.168.98.111:3389
$IPT -t nat -A PREROUTING -i $VPN2_IF -p tcp -m tcp --dport 3389 -j DNAT --to-destination $VPN2_RDP:3389
$IPT -t nat -A PREROUTING -i $VPN2_IF -p tcp -m tcp --dport 3398 -j DNAT --to-destination $VPN2_RDP2:3389
$IPT -t nat -A PREROUTING -i $VPN3_IF -p tcp -m tcp --dport 3389 -j DNAT --to-destination $VPN3_RDP:3389

### Prots forwarding for dkr vpn (nas-dkr) ###
$IPT -t nat -A PREROUTING -i $VPN4_IF -p tcp -m tcp --dport 8080 -j DNAT --to-destination $VPN4_SERVER:8080
$IPT -t nat -A PREROUTING -i $VPN4_IF -p tcp -m tcp --dport 443 -j DNAT --to-destination $VPN4_SERVER:443
$IPT -t nat -A PREROUTING -i $VPN4_IF -p tcp -m tcp --dport 101 -j DNAT --to-destination $VPN4_USER1:3389

### Prots forwarding for dkr vpn (Departamet inzenernih system) ###
#$IPT -t nat -A PREROUTING -i $VPN6_IF -p tcp -m tcp --dport 101 -j DNAT --to-destination $VPN6_RDP1:3389


##############################################


for site in $ISP2_SITE; do
	#nslookup 1cfresh.com > /tmp/site0.tmp
	tail -n +6 /tmp/site0.tmp | grep Address | cut -d" " -f2 > /tmp/site.tmp
	IP_SITE=`cat /tmp/site.tmp`
	for IP in $IP_SITE; do
		ip route add $IP via $ISP2_GW
	done
done


### Google Save ###

#ip route add 173.194.221.94 via $ISP2_GW
#ip route add 217.107.34.45 via $ISP2_GW

##################



#-------------------------------------------------------------------------------------------------------------------


#NAT
$IPT -t nat -A POSTROUTING -o $ISP1_IF -j MASQUERADE
$IPT -t nat -A POSTROUTING -o $ISP2_IF -j MASQUERADE
$IPT -t nat -A POSTROUTING -o $VPN0_IF -j MASQUERADE
$IPT -t nat -A POSTROUTING -o $VPN1_IF -j MASQUERADE
$IPT -t nat -A POSTROUTING -o $VPN2_IF -j MASQUERADE
$IPT -t nat -A POSTROUTING -o $VPN3_IF -j MASQUERADE
$IPT -t nat -A POSTROUTING -o $VPN4_IF -j MASQUERADE
$IPT -t nat -A POSTROUTING -o $VPN5_IF -j MASQUERADE
$IPT -t nat -A POSTROUTING -o $VPN6_IF -j MASQUERADE
####

#$IPT -t nat -A POSTROUTING -m mark --mark $ISP1_MK -j SNAT --to-source $ISP1_IP
#$IPT -t nat -A POSTROUTING -m mark --mark $ISP2_MK -j SNAT --to-source $ISP2_IP
#end

#iptables filter

$IPT -t filter -F

$IPT -t filter -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

#ICMP
$IPT -t filter -A INPUT -i lo -j ACCEPT
$IPT -t filter -A INPUT -i $LOCAL_IF -p icmp -j ACCEPT
$IPT -t filter -A INPUT -i $GUEST_IF -p icmp -j ACCEPT
#$IPT -t filter -A INPUT -i $ISP1_IF -p icmp -j ACCEPT
#$IPT -t filter -A INPUT -i $ISP2_IF -p icmp -j ACCEPT
$IPT -t filter -A INPUT -i $VPN0_IF -p icmp -j ACCEPT
$IPT -t filter -A INPUT -i $VPN1_IF -p icmp -j ACCEPT
$IPT -t filter -A INPUT -i $VPN2_IF -p icmp -j ACCEPT
$IPT -t filter -A INPUT -i $VPN3_IF -p icmp -j ACCEPT
$IPT -t filter -A INPUT -i $VPN4_IF -p icmp -j ACCEPT
$IPT -t filter -A INPUT -i $VPN5_IF -p icmp -j ACCEPT
$IPT -t filter -A INPUT -i $VPN6_IF -p icmp -j ACCEPT
#####


#Open ports
#Open ports for localnet
for OP in $LOCAL_TCP; do
$IPT -t filter -A INPUT -i $LOCAL_IF -p tcp -m conntrack --ctstate NEW -m tcp --dport $OP -j ACCEPT
done
for OP in $LOCAL_UDP; do
$IPT -t filter -A INPUT -i $LOCAL_IF -p udp -m conntrack --ctstate NEW -m udp --dport $OP -j ACCEPT
done
#Open ports for guest network
for OP in $GUEST_TCP; do
$IPT -t filter -A INPUT -i $GUEST_IF -p tcp -m conntrack --ctstate NEW -m tcp --dport $OP -j ACCEPT
done
for OP in $GUEST_UDP; do
$IPT -t filter -A INPUT -i $GUEST_IF -p udp -m conntrack --ctstate NEW -m udp --dport $OP -j ACCEPT
done
#Open ports for ISP1
for OP in $ISP1_TCP; do
$IPT -t filter -A INPUT -i $ISP1_IF -p tcp -m conntrack --ctstate NEW -m tcp --dport $OP -j ACCEPT
done
for OP in $ISP1_UDP; do
$IPT -t filter -A INPUT -i $ISP1_IF -p udp -m conntrack --ctstate NEW -m udp --dport $OP -j ACCEPT
done
#Open ports for ISP2
for OP in $ISP2_TCP; do
$IPT -t filter -A INPUT -i $ISP2_IF -p tcp -m conntrack --ctstate NEW -m tcp --dport $OP -j ACCEPT
done
for OP in $ISP2_UDP; do
$IPT -t filter -A INPUT -i $ISP2_IF -p udp -m conntrack --ctstate NEW -m udp --dport $OP -j ACCEPT
done
#Open ports for VPN0
for OP in $VPN0_TCP; do
$IPT -t filter -A INPUT -i $VPN0_IF -p tcp -m conntrack --ctstate NEW -m tcp --dport $OP -j ACCEPT
done
for OP in $VPN0_UDP; do
$IPT -t filter -A INPUT -i $VPN0_IF -p udp -m conntrack --ctstate NEW -m udp --dport $OP -j ACCEPT
done
#Open ports for VPN1
for OP in $VPN1_TCP; do
$IPT -t filter -A INPUT -i $VPN1_IF -p tcp -m conntrack --ctstate NEW -m tcp --dport $OP -j ACCEPT
done
for OP in $VPN1_UDP; do
$IPT -t filter -A INPUT -i $VPN1_IF -p udp -m conntrack --ctstate NEW -m udp --dport $OP -j ACCEPT
done
#Open ports for VPN2
for OP in $VPN2_TCP; do
$IPT -t filter -A INPUT -i $VPN2_IF -p tcp -m conntrack --ctstate NEW -m tcp --dport $OP -j ACCEPT
done
for OP in $VPN2_UDP; do
$IPT -t filter -A INPUT -i $VPN2_IF -p udp -m conntrack --ctstate NEW -m udp --dport $OP -j ACCEPT
done
#Open ports for VPN3
for OP in $VPN3_TCP; do
$IPT -t filter -A INPUT -i $VPN3_IF -p tcp -m conntrack --ctstate NEW -m tcp --dport $OP -j ACCEPT
done
for OP in $VPN3_UDP; do
$IPT -t filter -A INPUT -i $VPN3_IF -p udp -m conntrack --ctstate NEW -m udp --dport $OP -j ACCEPT
done
#Open ports for VPN4
for OP in $VPN4_TCP; do
$IPT -t filter -A INPUT -i $VPN4_IF -p tcp -m conntrack --ctstate NEW -m tcp --dport $OP -j ACCEPT
done
for OP in $VPN4_UDP; do
$IPT -t filter -A INPUT -i $VPN4_IF -p udp -m conntrack --ctstate NEW -m udp --dport $OP -j ACCEPT
done
#Open ports for VPN5
for OP in $VPN5_TCP; do
$IPT -t filter -A INPUT -i $VPN4_IF -p tcp -m conntrack --ctstate NEW -m tcp --dport $OP -j ACCEPT
done
for OP in $VPN5_UDP; do
$IPT -t filter -A INPUT -i $VPN4_IF -p udp -m conntrack --ctstate NEW -m udp --dport $OP -j ACCEPT
done
#Open ports for VPN6
for OP in $VPN6_TCP; do
$IPT -t filter -A INPUT -i $VPN4_IF -p tcp -m conntrack --ctstate NEW -m tcp --dport $OP -j ACCEPT
done
for OP in $VPN6_UDP; do
$IPT -t filter -A INPUT -i $VPN4_IF -p udp -m conntrack --ctstate NEW -m udp --dport $OP -j ACCEPT
done



##########

#Drops
$IPT -t filter -A INPUT -i $ISP1_IF -j DROP
$IPT -t filter -A INPUT -i $ISP2_IF -j DROP
$IPT -t filter -A INPUT -i $VPN0_IF -j DROP
$IPT -t filter -A INPUT -i $VPN1_IF -j DROP
$IPT -t filter -A INPUT -i $VPN2_IF -j DROP
$IPT -t filter -A INPUT -i $VPN3_IF -j DROP
$IPT -t filter -A INPUT -i $VPN4_IF -j DROP
$IPT -t filter -A INPUT -i $VPN5_IF -j DROP
$IPT -t filter -A INPUT -i $VPN6_IF -j DROP
#####



#$IPT -t filter -A INPUT -j REJECT --reject-with icmp-host-prohibited

$IPT -t filter -A FORWARD -p icmp -j ACCEPT

$IPT -t filter -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
#$IPT -t filter -A FORWARD -p icmp -j ACCEPT


for IP in $BAN_USER_IP; do
$IPT -A FORWARD -s $LOCAL_LAN.$IP -j DROP
done

#for IP in $ADOBE; do
#$IPT -A FORWARD -s $LOCAL_LAN.$IP -d $IP -j ACCEPT
#done

for IP in $BAN_SITE; do
#echo ''
$IPT -A FORWARD -s $LOCAL_NET -d $IP -j REJECT
	for IP2 in $ADOBE; do
		$IPT -A FORWARD -s $LOCAL_LAN.$IP2 -d $IP -j DROP
	done
done

$IPT -t filter -A FORWARD -s 192.168.0.0/16 -d 192.168.0.0/16 -j DROP

#$IPT -A FORWARD -m opendpi --bittorrent -j DROP

$IPT -t nat -A POSTROUTING -m mark --mark $ISP1_MK -j SNAT --to-source $ISP1_IP
$IPT -t nat -A POSTROUTING -m mark --mark $ISP2_MK -j SNAT --to-source $ISP2_IP
#$IPT -t nat -A POSTROUTING -m mark --mark $VPN0_MK -j SNAT --to-source $VPN0_IF

uptime=`uptime | sed 's/^[ \t]*//' | cut -d" " -f4`
echo "`date +'%Y/%m/%d %H:%M:%S'` !!!!!SCRIPT routing.sh RUNNING!!!!!" >>${LOGFILE}
echo "`date +'%Y/%m/%d %H:%M:%S'` !!!!!UPTIME IS $uptime!!!!!" >>${LOGFILE}

exit 0