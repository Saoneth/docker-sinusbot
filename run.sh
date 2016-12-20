#!/bin/sh

rm -rf /tmp/.X*
rm -f /tmp/TS3*

#cd /home/teamspeak/sinusbot
#/usr/bin/xinit /home/teamspeak/sinusbot/ts3bot -- /usr/bin/Xvfb :1 -screen 0 800x600x16 -ac
cd /home/teamspeak/TeamSpeak3-Client-linux_amd64
/usr/bin/xinit /home/teamspeak/sinusbot/sinusbot  -- /usr/bin/Xvfb :1 -screen 0 800x600x16 -ac
