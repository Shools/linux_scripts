#!/bin/bash

. /etc/routing/vars


bkp
$LOCAL_IF = eth0

eth0
eth0-2:10.isp2_vip
eth0-2:20.isp1_vip
eth0-2:50.isp2_df
eth0-2:60.isp1_df
eth0-2.root

eth1
eth1-2:21.isp1_vip
eth1-2:61.isp1_df
eth1-2:91.ban
eth1-2.root

eth2
eth2-2:12.isp2_vip
eth1-2:61.isp1_df
eth2-2:92.ban
eth2-2.root
