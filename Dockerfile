FROM ubuntu

MAINTAINER Saoneth <saoneth@gmail.com>

ENV TEAMSPEAK_URL http://dl.4players.de/ts/releases/3.0.19.4/TeamSpeak3-Client-linux_amd64-3.0.19.4.run
ENV SINUSBOT_URL https://www.sinusbot.com/dl/sinusbot-beta.tar.bz2
ENV YOUTUBEDL_URL https://github.com/rg3/youtube-dl/releases/download/2016.12.15/youtube-dl
ENV TS3_UID 1001
ENV LANG=C.UTF-8

# Install Teamspeak
ADD $TEAMSPEAK_URL /tmp/ts3.run
RUN sed -i 's/^MS_PrintLicense$//' /tmp/ts3.run && \
    chmod +x /tmp/ts3.run && \
    /tmp/ts3.run && \
    rm /tmp/ts3.run && \
    groupadd -g ${TS3_UID} teamspeak && \
    useradd -u ${TS3_UID} -g ${TS3_UID} -d /home/teamspeak -m teamspeak && \
    mv TeamSpeak3-Client-linux_amd64 /home/teamspeak/ && \
    chown -R teamspeak:teamspeak /home/teamspeak/ && \
    apt-get update && apt-get upgrade -y && apt-get install -y xinit xvfb libxcursor1 libglib2.0-0 bzip2

# Install SinusBot
ADD $SINUSBOT_URL /tmp/sinusbot.tar.bz2
ADD run.sh /home/teamspeak/sinusbot/run.sh
RUN tar -vxjf /tmp/sinusbot.tar.bz2 -C /home/teamspeak/sinusbot && \
    rm /tmp/sinusbot.tar.bz2 && \
    ln -s /home/teamspeak/sinusbot/plugin/libsoundbot_plugin.so /home/teamspeak/TeamSpeak3-Client-linux_amd64/plugins/libsoundbot_plugin.so && \
    mv /home/teamspeak/sinusbot/config.ini.dist /home/teamspeak/sinusbot/config.ini && \
    sed -i 's~^TS3Path = "[^"]*"$~TS3Path = "/home/teamspeak/TeamSpeak3-Client-linux_amd64/ts3client_linux_amd64"~' /home/teamspeak/sinusbot/config.ini && \
    chmod +x /home/teamspeak/sinusbot/sinusbot && \
#    /home/teamspeak/sinusbot/sinusbot -update -RunningAsRootIsEvilAndIKnowThat && \
    chmod +x /home/teamspeak/sinusbot/run.sh && \
    chown -R teamspeak:teamspeak /home/teamspeak/

# Install youtube-dl
ADD $YOUTUBEDL_URL /usr/local/bin/youtube-dl
RUN apt-get install -y python ca-certificates && \
    update-ca-certificates && \
    chmod a+rx /usr/local/bin/youtube-dl && \
    echo 'YouTubeDLPath = "/usr/local/bin/youtube-dl"' >> /home/teamspeak/sinusbot/config.ini

# Add ssl support
#WORKDIR /home/teamspeak/sinusbot
#RUN apt-get install -y libssl1.0.0
#ADD libavformat.so.57 .
#ADD libavcodec.so.57 .
#ADD libavfilter.so.6 .
#ADD libavutil.so.55 .
#ADD libswresample.so.2 .

RUN apt-get clean

USER teamspeak

ENTRYPOINT ["/home/teamspeak/sinusbot/run.sh"]

VOLUME ["/home/teamspeak/sinusbot/data"]

EXPOSE 8087
