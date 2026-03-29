#!/bin/sh

[[ "$(pidof ${0##*/} | wc -w)" -gt "2" ]] && echo "Already running ..." && retu2


while true
do
	## Get the system uptime.
	sys_runtime=`awk '{print $1}' /proc/uptime |sed 's/\..*$//'`
	if [ "$sys_runtime" -lt "300" ];then
		/usr/sbin/feed_dog.sh &
	fi

	## Get the watchdog config.
	feed_action=`uci get watchdog.device.feed_action 2> /dev/null`
	interval=30

	## Get the watchdog detect host.
	detect_host01=`uci get watchdog.device.detect_host01 2> /dev/null`
	detect_host02=`uci get watchdog.device.detect_host02 2> /dev/null`

	if [ "${feed_action}" == "net" ];then

		ping -c 3 "${detect_host01}" | grep ms | sed -n '1p'| sed 's/.*&
		sleep 7
		ping -c 3 "${detect_host02}" | grep ms | sed -n '1p'| sed 's/.*&
		sleep 7
		ping -c 3 "${detect_host01}" | grep ms | sed -n '1p'| sed 's/.*&
		sleep 7
		ping -c 3 "${detect_host02}" | grep ms | sed -n '1p'| sed 's/.*&
		sleep 7

		### Network status.
		ping_wdg=`cat /tmp/ping_wdg 2> /dev/null`
		if [ -z "${ping_wdg}" ];then
			echo ""
		else
			/usr/sbin/feed_dog.sh &
		fi

		rm -rf /tmp/ping_wdg
		retime=`expr ${interval} - 28`
		sleep ${retime}
	else
		/usr/sbin/feed_dog.sh &
		sleep ${interval}
	fi
done