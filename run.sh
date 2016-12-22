#!/bin/sh
rm -rf /tmp/.X*
rm -f /tmp/TS3*
/usr/bin/xinit /home/teamspeak/sinusbot/sinusbot  -- /usr/bin/Xvfb :1 -screen 0 800x600x16 -ac
