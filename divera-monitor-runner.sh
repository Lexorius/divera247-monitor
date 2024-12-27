#!/bin/bash


# This File is modified based on original file from https://family-giese.de/Bewegungsmelder - Please leave support on the original page. 



ACCESSKEY=""  # ACCESSKEY from Diver Management API - NOT Personal api
API_URL="https://www.divera247.com/api/last-alarm?accesskey=${ACCESSKEY}"

MQTT_SERVER="homeassistant.local" # Change here to local mqtt server
MQTT_USER="diveramonitor"         # Change to your mqtt user 
MQTT_PASS="diveramonitorpassword" # change to your mqtt password
MQTT_DUTY_TOPIC="tv/duty"		  # Change to your Topic for dutycycle
MQTT_MOTION_TOPIC="tv/motion"	  # Change to your Topic for Motion
MQTT_STATUS_TOPIC="tv/status"     # Change to your Topic where script is sending answer to.

# Set Monitor Active for Boottime:

IS_MONITOR_ACTIVE=true

# includes the divera commands
source /usr/local/bin/divera_commands.sh

# at boot show the monitor
monitor on


# we run the script in Desktopenviroment - so lets unclutter
unclutter -display :0 -noevents - grab

# does not allow the raspberry to go to sleep 
xset s off
xset s noblank
xset -dpms




# MAIN Loop 
 
while true; do
	# Check Divera Alarm Page if a alarm is set 
    HAS_ALARM=`curl -s ${API_URL} | jq -r -j '.success'` 
	# Check MQTT if something triggert Motion 
    MOTION=`mosquitto_sub  -h ${MQTT_SERVER} -u ${MQTT_USER} -P ${MQTT_PASS} -t ${MQTT_MOTION_TOPIC} --retained-only  -C 1`
	#Initialize Var DUTY_TIME to False
    DUTY_TIME=false
	# Check MQTT if a Duty is set
    DUTY_TIME=`mosquitto_sub  -h ${MQTT_SERVER} -u ${MQTT_USER} -P {$MQTT_PASS} -t ${MQTT_DUTY_TOPIC}  -C 1 ` 
	
    
    #case: active mission and monitor off
    if [ $HAS_ALARM = true ] && [ $IS_MONITOR_ACTIVE = false ] ; then
        echo "divera alarm is set - display on"
        screen on
        IS_MONITOR_ACTIVE=true
        
    #case: duty time and mission off
    elif [ $MOTION = true ] && [ $IS_MONITOR_ACTIVE = false ]; then
    
        echo "MQTT Motion is true -  display on"
        screen on
        IS_MONITOR_ACTIVE=true
    
    elif [ $DUTY_TIME = true ] && [ $IS_MONITOR_ACTIVE = false ]; then
        
        echo "MQTT Duty is true - display on"
        screen on
        IS_MONITOR_ACTIVE=true

    #case: no Alarm and no motion and no duty time but monitor on
    elif [ $HAS_ALARM = false ] && [ $MOTION = false ] && [ $DUTY_TIME = false ] && [ $IS_MONITOR_ACTIVE = true ]; then
        echo "Turn display off"
        screen off
        IS_MONITOR_ACTIVE=false
    
    #case: monitor off and no mission and it is night time then make updates
    elif [ $HAS_ALARM = false ] && [ $IS_MONITOR_ACTIVE = false ] && [ $HOUR = 3 ] && [ $MINUTES = 5 ]; then
        echo "Maintainance task - update and restarting Raspberry"

        #wait a moment that he wont do two updates when he is faster then a minute with update and reboot
        sleep 45

        sudo apt update
        sudo apt --yes --force-yes upgrade
        sudo reboot
    fi
    
   echo "screen $IS_MONITOR_ACTIVE"
    #sleeps 30 seconds and starts again
    sleep 30
done
