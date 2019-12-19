#!/bin/bash

# STATE=0 => work
# STATE=1 => not work
ISP1_STATE="0"
ISP2_STATE="$ISP1_STATE"
ISP1_STATE_LAST="$ISP1_STATE"
ISP2_STATE_LAST="$ISP2_STATE"

while true; do

. /etc/routing/vars

###Internet tests#####################
ping -c 10 $TEST1 -I $ISP1_IF > /dev/null
if [ $? -ne 0 ]; then
	ISP1_STATE_NEW="1"
else
	ISP1_STATE_NEW="0"
fi

ping -c 10 $TEST2 -I $ISP2_IF > /dev/null
if [ $? -ne 0 ]; then
	ISP2_STATE_NEW="1"
else
	ISP2_STATE_NEW="0"
fi

###END#################################

if  [ "$ISP1_STATE_LAST" -ne "$ISP1_STATE_NEW" ] || [ "$ISP2_STATE_LAST" -ne "$ISP2_STATE_NEW" ] ; then

	###All internet are GOOD###################
	if [ $ISP1_STATE_NEW -eq $ISP1_STATE ] && [ $ISP2_STATE_NEW -eq $ISP2_STATE ]; then
		. /etc/routing/routing.sh

		echo "`date +'%Y/%m/%d %H:%M:%S'` All internet connections are working" >>${LOGFILE}
		#echo "`date +'%Y/%m/%d %H:%M:%S'` All internet connections are working." | mail -s "Internet warning from $HOSTNAME" $MAILADM
	###END################################

        ###All internet DOWN##################
        elif [ $ISP1_STATE_NEW -ne $ISP1_STATE ] && [ $ISP2_STATE_NEW -ne $ISP2_STATE ]; then
                echo "`date +'%Y/%m/%d %H:%M:%S'` !!! All Internet are Failed !!!" >>${LOGFILE}
        fi
        ###END################################

        ###Internet 1 DOWN####################
        elif [ $ISP1_STATE_NEW -ne $ISP1_STATE ] && [ $ISP2_STATE_NEW -eq $ISP2_STATE  ]; then
                ip route delete default
                ip route add default via $ISP2_GW #dev $ISP2_IF
		$IPT -t mangle -D PREROUTING -s $LOCAL_NET -j MARK --set-mark $ISP1_MK
                $IPT -t mangle -D PREROUTING -s $LOCAL_NET -j MARK --set-mark $ISP2_MK
		$IPT -t mangle -A PREROUTING -s $LOCAL_NET -j MARK --set-mark $ISP2_MK
		for IP in $ISP1_ONLY; do
			$IPT -t mangle -D PREROUTING -s $LOCAL_LAN.$IP -j MARK --set-mark $ISP1_MK
		done

	        echo "`date +'%Y/%m/%d %H:%M:%S'` ! $ISP1 are Failed !" >>${LOGFILE}
        ###END################################

	###Internet 2 DOWN####################
	elif [ $ISP1_STATE_NEW -eq $ISP1_STATE ] && [ $ISP2_STATE_NEW -ne $ISP1_STATE ]; then
		ip route delete default
		ip route add default via $ISP1_GW #dev $ISP1_IF
                $IPT -t mangle -D PREROUTING -s $LOCAL_NET -j MARK --set-mark $ISP1_MK
                $IPT -t mangle -D PREROUTING -s $LOCAL_NET -j MARK --set-mark $ISP2_MK
                $IPT -t mangle -A PREROUTING -s $LOCAL_NET -j MARK --set-mark $ISP1_MK
		for IP in $ISP2_ONLY; do
		        $IPT -t mangle -D PREROUTING -s $LOCAL_LAN.$IP -j MARK --set-mark $ISP2_MK
			
		done

		echo "`date +'%Y/%m/%d %H:%M:%S'` ! $ISP2 are Failed !" >>${LOGFILE}
	###END################################

	###Debug##############################
	#else
	#echo "!!!!!!Not changed"
	###END################################
fi

ISP1_STATE_LAST="$ISP1_STATE_NEW"
ISP2_STATE_LAST="$ISP2_STATE_NEW"

sleep 3
done