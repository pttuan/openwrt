#!/bin/sh

file_name='/tmp/fan_ctl.log'
max_bytes='1048576'
## 判断日志大小是否超过阈值
log_check() {

	local file_name="$1"
	local max_bytes="$2"
	local log_bytes=`ls -l "${file_name}" | sed 's/\ \{1,\}/\ /g' | cut -d "
 " -f5`
	[ "${log_bytes}" -ge "${max_bytes}" ] && rm -rf ${file_name}
}

fan_ctl() {

	local period="$1"
	local duty_cycle="$2"
	local stat="$3"

	echo "${period}" > /sys/class/pwm/pwmchip0/pwm0/period
	echo "${duty_cycle}" > /sys/class/pwm/pwmchip0/pwm0/duty_cycle
	echo "${stat}" > /sys/class/pwm/pwmchip0/pwm0/enable
}

now=`date +%Y%m%d-%H%M%S`
temp=`cat /sys/devices/virtual/thermal/thermal_zone0/temp 2> /dev/null`
temp_val=`expr $temp / 1000`

old_duty_cycle=`cat /sys/class/pwm/pwmchip0/pwm0/duty_cycle 2> /dev/null`
old_stat=`cat /sys/class/pwm/pwmchip0/pwm0/enable 2> /dev/null`
if [ "${temp_val}" -ge "65" ] ;then
	period='100000000'
	duty_cycle='100000000'
	stat='1'

elif [ "${temp_val}" -ge "40" ] ;then
	period='100000000'
	duty_cycle='50000000'
	stat='1'
else
	period='100000000'
	duty_cycle='50000000'
	stat='0'
fi

fan_ctl "${period}" "${duty_cycle}" "${stat}"
if [ "${duty_cycle}" != "${old_duty_cycle}" ] || [ "${stat}" != "${old_stat}" ] ;then
	log_check "${file_name}" "${max_bytes}"
	echo "date: ${now} | temp: ${temp_val} | period: ${period} | duty_cycle: ${duty_cycle} | enable: ${stat}" >> ${file_name}
fi