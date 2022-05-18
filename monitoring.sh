#!/bin/bash
hostIP=$(hostname -I)
macAddress=$(cat /sys/class/net/enp0s3/address)
physical_procc=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)
vCPU=$(grep "^processor" /proc/cpuinfo | wc -l)
Total_MB=$(free -t -m | awk 'FNR == 2 {printf("#Memory Usage: %d/%dMB (%.2f%%)\n"), $3, $2, $3/$2*100}')
Disk_Free=$(df -h | awk '$NF=="/"{printf "#Disk Usage: %d/%dGb (%s)", $3, $2, $5}')
LVM_Use=$(lsblk | grep lvm | awk '{if ($1) {print "yes"; exit;} else {print "no"} }')
CPU_Use=$(top -bn1 | grep load | awk '{printf "#CPU LOAD: %.1f%%\n", $(NF-2)}')
Last_Boot=$(who -b | awk '{print $3" "$4}')
Active_Users=$(ss | grep -i 'tcp\|ssh' | wc -l)
Unique_Users=$(who | cut -d ' ' -f 1 | uniq -c | wc -l)
Sudo_Uses=$(cat /var/log/sudo/sudo.log | grep COMMAND | wc -l)
Kernal_Sys=$(hostnamectl | grep 'Kernel' | cut -d':' -f2)
Arch=$(hostnamectl | grep 'Architecture' | cut -d':' -f2)
OS=$(hostnamectl | grep 'Operating System' | cut -d':' -f2)
echo -n "" > test.txt
echo "#Architecture:" $Kernal_Sys $OS $Arch >> test.txt
echo "#CPU physical :" $physical_procc >> test.txt
echo "#vCPU :" $vCPU >> test.txt
echo $Total_MB >> test.txt
echo $Disk_Free >> test.txt
echo $CPU_Use >> test.txt
echo "#Last Boot: " $Last_Boot >> test.txt
echo "#LVM Use: " $LVM_Use >> test.txt
echo "#Connections TCP :" $Active_Users " ESTABLISHED" >> test.txt
echo "#User log: " $Unique_Users >> test.txt
echo "#Network: IP " $hostIP " (" $macAddress ")" >> test.txt
echo -n "#Sudo : " $Sudo_Uses " cmd" >> test.txt
cat test.txt | wall
