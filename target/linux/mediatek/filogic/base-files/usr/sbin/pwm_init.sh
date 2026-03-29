#!/bin/sh

## 日志信息
now=`date +%Y%m%d-%H%M%S`
file_name='/tmp/fan_ctl.log'

temp=`cat /sys/devices/virtual/thermal/thermal_zone0/temp 2> /dev/null`
temp_val=`expr $temp / 1000`

period='100000000'
duty_cycle='50000000'
stat='1'

echo "0" > /sys/class/pwm/pwmchip0/export
echo "${period}" > /sys/class/pwm/pwmchip0/pwm0/period
### 占空比50%
echo "${duty_cycle}" > /sys/class/pwm/pwmchip0/pwm0/duty_cycle
echo "${stat}" > /sys/class/pwm/pwmchip0/pwm0/enable

rm -rf ${file_name}
echo "=============================" >> ${file_name}
echo "PWM fan Start !!!" >> ${file_name}
echo "date: ${now} | temp: ${temp_val} | period: ${period} | duty_cycle: ${duty_cycle} | enable: ${stat}" >> ${file_name}