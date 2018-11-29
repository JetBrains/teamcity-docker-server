FROM adoptopenjdk/openjdk8:x86_64-ubuntu-jdk8u192-b12
MAINTAINER Kateryna Shlyakhovetska <shkate@jetbrains.com>
MAINTAINER Vladislav Rassokhin <vladislav.rassokhin@jetbrains.com>

ENV TEAMCITY_DATA_PATH=/data/teamcity_server/datadir \
    TEAMCITY_DIST=/opt/teamcity \
    TEAMCITY_LOGS=/opt/teamcity/logs

EXPOSE 8111
LABEL dockerImage.teamcity.version="latest" \
      dockerImage.teamcity.buildNumber="latest"

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 323293EE && \
    echo "deb http://ppa.launchpad.net/mercurial-ppa/releases/ubuntu xenial main" > /etc/apt/sources.list.d/mercurial.list
RUN apt-get update && \
    apt-get install -y git mercurial ca-certificates && \
    apt-get clean all

COPY welcome.sh /welcome.sh
RUN chmod +x /welcome.sh && sync && \
    echo '[ ! -z "$TERM" -a -x /welcome.sh -a -x /welcome.sh ] && /welcome.sh' >> /etc/bash.bashrc

COPY run-server.sh /run-server.sh
COPY run-services.sh /run-services.sh
RUN chmod +x /run-server.sh /run-services.sh && sync
COPY dist/teamcity $TEAMCITY_DIST

VOLUME $TEAMCITY_DATA_PATH \
       $TEAMCITY_LOGS

CMD ["/run-services.sh"]