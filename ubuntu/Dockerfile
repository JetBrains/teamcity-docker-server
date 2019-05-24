FROM adoptopenjdk/openjdk8:x86_64-ubuntu-jdk8u192-b12

ENV TEAMCITY_DATA_PATH=/data/teamcity_server/datadir \
    TEAMCITY_DIST=/opt/teamcity \
    TEAMCITY_LOGS=/opt/teamcity/logs \
    LANG=C.UTF-8

EXPOSE 8111
LABEL dockerImage.teamcity.version="latest" \
      dockerImage.teamcity.buildNumber="latest"

RUN apt-get update && \
    apt-get install -y git mercurial ca-certificates && \
    apt-get clean all

COPY welcome.sh /welcome.sh
COPY run-server.sh /run-server.sh
COPY run-services.sh /run-services.sh

RUN chmod +x /welcome.sh /run-server.sh /run-services.sh && sync && \
    groupadd -g 1000 tcuser && \
    useradd -r -u 1000 -g tcuser tcuser && \
    echo '[ ! -z "$TERM" -a -x /welcome.sh -a -x /welcome.sh ] && /welcome.sh' >> /etc/bash.bashrc

COPY --chown=tcuser:tcuser dist/teamcity $TEAMCITY_DIST


VOLUME $TEAMCITY_DATA_PATH \
       $TEAMCITY_LOGS

CMD ["/run-services.sh"]