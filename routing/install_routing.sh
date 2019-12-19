#!/bin/sh

. ./vars.sh

mkdir /etc/routing
cp vars /etc/routing/
cp routing.sh /etc/routing/
cp check.sh /etc/routing/
cp install.sh /etc/routing/
chown -R root:root /etc/routing
chmod 755 /etc/routing
touch /var/log/internet_warning.log
chmod 644 /var/log/internet_warning.log


cp /etc/iproute2/rt_tables /etc/iproute2/rt_tables.bak
echo "$TB1N     $TB1" >> /etc/iproute2/rt_tables
echo "$TB2N     $TB2" >> /etc/iproute2/rt_tables
echo "$TB0N     $TB0" >> /etc/iproute2/rt_tables

sysctl -w net.ipv4.ip_forward=1
cp /etc/sysctl.conf /etc/sysctl.conf.bak
sed 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf > /tmp/sysctl.conf_tmp
cat /tmp/sysctl.conf_tmp > /etc/sysctl.conf
rm -rf /tmp/sysctl.conf_tmp

cp /etc/rc.local /etc/rc.local.bak
sed  13i\ '/etc/routing/routing.sh' /etc/rc.local > /tmp/rc.local_tmp
sed  14i\ 'nohup /etc/routing/check.sh &' /tmp/rc.local_tmp > /tmp/rc.local_tmp1
cat /tmp/rc.local_tmp1 > /etc/rc.local
rm -rf /tmp/rc.local_tmp
rm -rf /tmp/rc.local_tmp1

/etc/routing/routing.sh
nohup /etc/routing/check.sh &
