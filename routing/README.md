# Bash/Shell scripts for routing traffic with iptables, iproute2 and htb.

## Main scripts
- The file "vars.sh" contains mutable variables.
- The file "routing.sh" is the main script for routing Internet traffic with multiple ISPs (Two ISPs).
- The file "check.sh" is a script for checking Internet connections using the ping command to Google DNS (8.8.8.8 and 8.8.4.4) and emergency changes to user connections.
- The file "install_routing.sh" is the script for the first installatino of routing scripts on the system.

## Scripts for QoS
### htb.sh

### htb_restart.sh

### install_qos.sh


## ls -l /etc/routing/

1. drwxr-xr-x 2 root root  4096 Jan 30  2017 bkp
2. -rwxr-xr-x 1 root root  2933 Dec  9 10:21 check.sh
3. drwxr-xr-x 7 root root  4096 Sep  3  2018 htb
4. -rwxr-xr-x 1 root root   287 Dec 14  2016 htb.sh
5. -rwxr-xr-x 1 root root    41 Feb 13  2017 htb_restart.sh
6. -rwxr-xr-x 1 root root   673 Feb 13  2017 install_qos.sh
7. -rwxr-xr-x 1 root root  1056 Dec 19 23:44 install_routing.sh
8. -rw------- 1 root root     0 Feb 27  2017 nohup.out
9. -rwxr-xr-x 1 root root 16972 Dec 19 23:25 routing.sh
10. -rwxr-xr-x 1 root root 15508 Feb 16  2017 routing.sh.bak.good
11. -rwxr-xr-x 1 root root  4382 Dec  8 22:48 vars.sh

## ls -l /etc/routing/htb

drwxr-xr-x 6 root root 4096 May 11  2017 backup_05052017
drwxr-xr-x 2 root root 4096 Mar 14  2018 backup_20180314
drwxr-xr-x 2 root root 4096 Dec 14  2016 bkp
lrwxrwxrwx 1 root root    4 May  5  2017 eth0 -> eth3
-rwxr-xr-x 1 root root   23 May  5  2017 eth0-2.root
lrwxrwxrwx 1 root root   18 May  5  2017 eth0-2:10.isp2_vip -> eth3-2:10.isp2_vip
lrwxrwxrwx 1 root root   18 May  5  2017 eth0-2:20.isp1_vip -> eth3-2:20.isp1_vip
-rwxr-xr-x 1 root root   79 May  6  2018 eth0-2:30.isp1_mail
-rwxr-xr-x 1 root root   51 Dec 18  2017 eth0-2:50.isp2_df
-rwxr-xr-x 1 root root   51 May  6  2018 eth0-2:60.isp1_df
-rwxr-xr-x 1 root root   47 May  5  2017 eth0-2:90.ban
lrwxrwxrwx 1 root root    4 Feb 13  2017 eth1 -> eth0
-rwxr-xr-x 1 root root   22 May  6  2018 eth1-2.root
lrwxrwxrwx 1 root root   18 Feb 13  2017 eth1-2:21.isp1_vip -> eth0-2:20.isp1_vip
lrwxrwxrwx 1 root root   19 Mar 14  2018 eth1-2:31.isp1_mail -> eth0-2:30.isp1_mail
lrwxrwxrwx 1 root root   17 Feb 13  2017 eth1-2:61.isp1_df -> eth0-2:60.isp1_df
lrwxrwxrwx 1 root root   13 Feb 13  2017 eth1-2:91.ban -> eth0-2:90.ban
lrwxrwxrwx 1 root root    4 Feb 13  2017 eth2 -> eth0
-rwxr-xr-x 1 root root   22 Dec 18  2017 eth2-2.root
lrwxrwxrwx 1 root root   18 Feb 13  2017 eth2-2:12.isp2_vip -> eth0-2:10.isp2_vip
lrwxrwxrwx 1 root root   17 Feb 13  2017 eth2-2:52.isp2_df -> eth0-2:50.isp2_df
lrwxrwxrwx 1 root root   13 Feb 13  2017 eth2-2:92.ban -> eth0-2:90.ban
-rwxr-xr-x 1 root root   11 May  5  2017 eth3
-rwxr-xr-x 1 root root   23 Dec 14  2016 eth3-2.root
-rwxr-xr-x 1 root root   55 May  7  2018 eth3-2:10.isp2_vip
-rwxr-xr-x 1 root root   56 May  6  2018 eth3-2:20.isp1_vip
-rwxr-xr-x 1 root root   78 Jan 26  2017 eth3-2:30.isp1_mail
-rwxr-xr-x 1 root root   51 Aug  3  2017 eth3-2:50.isp2_df
-rwxr-xr-x 1 root root   50 Sep  3  2018 eth3-2:60.isp1_df
-rwxr-xr-x 1 root root   49 May  5  2017 eth3-2:90.ban
-rw-r--r-- 1 root root 5589 May  6  2018 htb_integr_20180506.zip
-rwxr-xr-x 1 root root   41 Dec  5  2016 htb_restart.sh
drwxr-xr-x 2 root root 4096 Feb 13  2017 new
drwxr-xr-x 2 root root 4096 Dec 14  2016 variant1
