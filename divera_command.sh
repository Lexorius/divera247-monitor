#!/bin/bash


# This File is modified based on original file from https://family-giese.de/Bewegungsmelder - Please leave support 

# This file is an extension for the bash which contains the commands for
# turning the screen ond and off and also starts and stops the monitor.
# Source this file in your bash.rc to have the commands in your terminal.

# The url of your monitor (with Acesskey for autologin).
# This is the monitor account and not the alarm accesskey
# Also replace the braces
# REPLACE AUTOLOGIN_KEY with Autologin from Divera / Verwaltung(management) / Monitor key

MONITOR="https://app.divera247.com/monitor/1.html?autologin=<autologin_key>"

# This function starts or stops the divera monitor.
function monitor(){
        if [ $1 = on ]; then
                # starts chromium in in kiosk mode
                chromium-browser --noerrdialogs  --disable-translate --disable-cache --disable-features=Translate --kiosk --incognito $MONITOR &>/dev/null &
        elif [ $1 = off ]; then
                # just kill every chromium process
                pkill chromium >/dev/null
        else
                echo Unknown parameter
        fi
}

# Turns the screen on and off. Every screen is diffrent and many are bad programmed
# for that here are two diffrent ways for turning it on and off.
function screen(){
        if [ $1 = on ]; then
                echo on 0 | cec-client -s -d 1
        elif [ $1 = off ]; then
                # Version 1: disable hdmi port that the screen goes in standby
                vcgencmd display_power 0 >/dev/null
                # Version 2: send cec-signal to the screen that he should go in standby
                echo standby 0 | cec-client -s -d 1
        else
                echo Unknown parameter
        fi
}
