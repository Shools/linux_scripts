#!/bin/sh

. /etc/routing/vars

#echo $DIR
DIR=$DIR"htb/new/"

rm -rf $DIR"*"

#QOS local traffic
LOCAL_DEFAULT=$DIR"$LOCAL_IF"
touch $LOCAL_DEFAULT
echo "DEFAULT=70" > $LOCAL_DEFAULT
#QOS download ISP1


#QOS download ISP2

echo $LOCAL_DEFAULT
echo $DIR"$ISP1_IF"
#QOS upload ISP1
ln -s $LOCAL_DEFAULT $DIR"$ISP1_IF"

ISP1_ROOT=$DIR"$ISP1_IF""-2.root"
touch $ISP1_ROOT
echo "RATE=$ISP1_UPL""Mbit" > $ISP1_ROOT
echo 'Burst=15k' >> $ISP1_ROOT


#QOS upload ISP1
ln -s $LOCAL_DEFAULT $ISP2_IF

ISP2_ROOT=$DIR"$ISP2_IF""-2.root"
touch $ISP2_ROOT
echo "RATE=$ISP2_UPL""Mbit" > $ISP2_ROOT
echo 'Burst=15k' >> $ISP2_ROOT


chown -R root:root $DIR"*"
chmod -R 755 $DIR"*"

exit 0