#!/bin/sh

IPT="/sbin/iptables"
DIR="/etc/routing/"
#Log file
LOGFILE="/var/log/internet_warning.log"

############### change parameters #####################################
#Mail for email warning
MAILADM="ivanovsa88@gmail.com"

####ip Beeline only (192.168.98.X)
ISP1_ONLY=""
#####ip Westcall only
ISP2_ONLY_REGULAR="1 2 8 10 80 11 16 19 21 37 40 67 70 74 75 77 78 85 88 89 90 98 99 100 108 115 117 128 137 142 144 148 153 154 164 173 185 186 204 229 231"
ISP2_ONLY_TEMP="3 4 32 217 221 226 190 17 238 174 129 175 136 133 194 200 72 111 67 "
ISP2_ONLY=$ISP2_ONLY_TEMP$ISP2_ONLY_REGULAR
ISP2_ONLY=""
#ISP2_SITE="1cfresh.com integr.bitrix24.ru mirror.yandex.ru 1c.ru"
ISP2_SITE=""
#ISP2_ONLY="111"
#ip no proxy
#NOSQUID="$INET2_ONLY 22 23 64 93 73 76 79 80 98 101 104 112 121 124 140 142 144 146 159 161 162 167 170 172 182 184 200 209 211 212 217 221 222 224 228 246 157 218 92"
NOSQUID="111 2"

#IF0__TCP="20 21 22 123 137 138 139 161 445 667 3128 3129 3551 10050 10000"
#IF0_UDP="53 67 68 69 123 137 138 139 161 162 10050"

BAN_USER_IP=""
#BAN_SITE=""
#iuqerfsodp9ifjaposdfjhgosurijfaewrwergwea.com
BAN_SITE=""
#lmlicenses.wip4.adobe.com lm.licenses.adobe.com na1r.services.adobe.com hlrcv.stage.adobe.com activate.adobe.com youtube.com"
#"lmlicenses.wip4.adobe.com lm.licenses.adobe.com na1r.services.adobe.com hlrcv.stage.adobe.com practivate.adobe.com activate.adobe.com"
ADOBE="74 89 25 88"
############### END ###################################################
#ISP2_SITE="1cfresh.com"


#Localnet interface (Integrator)
LOCAL_IF="eth3"
#LOCAL_IF1="br0"
LOCAL_IP="192.168.98.23"
LOCAL_NET="192.168.98.0/16"
LOCAL_LAN="192.168.98"
LOCAL_TB="integrator"
LOCAL_TBN="10"
LOCAL_TCP="22 53 80 123 3000 3128 3129 10000 10050"
LOCAL_UDP="53 67 68 123 4011"
LOCAL_DOWNL="100" #Mbit/sec
LOCAL_UPL="100"   #Mbit/sec

#Guest interface
GUEST_IF="eth3:1"
GUEST_IP="192.168.47.1"
GUEST_NET="192.168.47.0/24"
GUEST_LAN="192.168.47"
GUEST_TB="guest"
GUEST_TBN="9"
GUEST_TCP="53"
GUEST_UDP="53 67 68"
GUEST_DOWNL="100" #Mbit/sec
GUEST_UPL="100"	  #Mbit/sec

#Inet 1 interface (Beeline)
ISP1="Beeline"
ISP1_IF="eth1"
ISP1_IP="212.46.235.166"
ISP1_NET="212.46.235.164/30"
ISP1_GW="212.46.235.165"
ISP1_TB="beeline"
ISP1_TBN="11"
ISP1_MK="1"
ISP1_TCP=""
ISP1_UDP="1194 1195 1196 1197 1198 1199 1200"
ISP1_DOWNL="50" #Mbit/sec
ISP1_UPL="50"	#Mbit/sec

#Inet 2 interface (Westcall)
ISP2="Westcall"
ISP2_IF="eth2"
ISP2_IP="217.173.79.126"
ISP2_NET="217.173.79.124/30"
ISP2_GW="217.173.79.125"
ISP2_TB="westcall"
ISP2_TBN="12"
ISP2_MK="2"
ISP2_TCP=$ISP1_TCP
ISP2_UDP=$ISP1_UDP
ISP2_DOWNL="15" #Mbit/sec
ISP2_UPL="10"   #Mbit/sec

#VPN for 1c 1194
VPN0_IF="tun0"
VPN0_IP="10.1.1.1"
VPN0_NET="10.1.1.0/24"
VPN0_TB="vpn0"
VPN0_TBN="100"
VPN0_MK="3"
VPN0_TCP=""
VPN0_UDP=""
#VPN0_RDP="192.168.0.11"
VPN0_RDP="192.168.98.11" #Servbest
VPN0_RDP2="192.168.98.157" #Fin01
VPN0_CLIENT2="10.1.1.54/32"

#VPN for networks 1195
VPN1_IF="tun1"
VPN1_IP="10.11.11.1"
VPN1_NET="10.11.11.0/24"
VPN1_TB="vpn1"
VPN1_TBN="101"
VPN1_MK="6"
VPN1_TCP="22 3000 10000"
VPN1_UDP=""
VPN1_RESOURCE="192.168.98.1 192.168.98.2 192.168.98.9 192.168.98.111 192.168.98.210 192.168.99.71 192.168.99.72 192.168.99.100"


#VPN for Landef-buh 1196
VPN2_IF="tun2"
VPN2_IP="10.12.12.1"
VPN2_NET="10.12.12.0/24"
VPN2_TB="vpn2"
VPN2_TBN="102"
VPN2_MK="7"
VPN2_TCP=""
VPN2_UDP=""
VPN2_RDP="192.168.98.228" #Roslova
VPN2_RDP2="192.168.98.137" #Lysikova

#VPN for Vekshin 1197
VPN3_IF="tun3"
VPN3_IP="10.13.13.1"
VPN3_NET="10.13.13.0/24"
VPN3_TB="vpn3"
VPN3_TBN="103"
VPN3_MK="8"
VPN3_TCP=""
VPN3_UDP=""
VPN3_RDP="192.168.98.221"

#VPN for DKR (NAS-DKR) 1198
VPN4_IF="tun4"
VPN4_IP="10.14.14.1"
VPN4_NET="10.14.14.0/24"
VPN4_TB="vpn4"
VPN4_TBN="104"
VPN4_MK="9"
VPN4_TCP=""
VPN4_UDP=""
VPN4_SERVER="192.168.98.210"
VPN4_USER1="192.168.98.233"

#VPN for integrator-local 1199
VPN5_IF="tun5"
VPN5_IP="10.98.98.1"
VPN5_NET="10.98.98.0/24"
VPN5_TB="vpn5"
VPN5_TBN="105"
VPN5_MK="10"
VPN5_TCP=""
VPN5_UDP=""

#VPN for integrator-dis 1200
VPN6_IF="tun6"
VPN6_IP="10.14.15.1"
VPN6_NET="10.14.15.0/24"
VPN6_TB="vpn6"
VPN6_TBN="106"
VPN6_MK="11"
VPN6_TCP=""
VPN6_UDP=""
VPN6_RDP1=""

#Ports for VPN cliets
SSH="22"
RDP="3389"
RDP_VEKSHIN="55444"
RDP_1C="55555"

#Default gate&mark
DGW=$ISP1_GW
DMK=$ISP1_MK

#Test hosts for check internet
#TEST1="$GW1"
#TEST2="$GW2"
TEST1="8.8.8.8"
TEST2="8.8.4.4"

#HTB (QoS) settings
HTB_FOLDER="/etc/routing/htb"