#!/bin/sh

echo "1" > /sys/class/gpio/wdg/value
sleep 1
echo "0" > /sys/class/gpio/wdg/value
sleep 1