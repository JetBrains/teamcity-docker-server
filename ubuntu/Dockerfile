FROM adoptopenjdk/openjdk8:x86_64-ubuntu-jdk8u192-b12

ARG JDBC_VER=8.0.13

ENV TEAMCITY_DATA_PATH=/data/teamcity_server/datadir \
    TEAMCITY_DIST=/opt/teamcity \
    TEAMCITY_LOGS=/opt/teamcity/logs \
    TEAMCITY_SERVER_MEM_OPTS="-Xmx2g -XX:ReservedCodeCacheSize=350m" \
    LANG=C.UTF-8

EXPOSE 8111
LABEL dockerImage.teamcity.version="latest" \
      dockerImage.teamcity.buildNumber="latest"

RUN buildDeps=' \
        gnupg \
    ' \
    && apt-get update \
    && apt-get install -y --no-install-recommends $buildDeps \
    && curl -fsSL https://package.perforce.com/perforce.pubkey | apt-key add - \
    && mkdir -p /etc/apt/sources.list.d \
    && ( \
        . /etc/os-release && \
        echo "deb http://package.perforce.com/apt/$ID $VERSION_CODENAME release" \ 
	 > /etc/apt/sources.list.d/perforce.list \
    ) \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        git \
        helix-cli \
        mercurial \
    && apt-get purge -y --auto-remove $buildDeps \
    && rm -rf /var/lib/apt/lists/*

# Restore this if the libmysql-java package is updated
#RUN mkdir -p $TEAMCITY_DATA_PATH/lib/jdbc && \
#    ln -s /usr/share/java/mysql.jar $TEAMCITY_DATA_PATH/lib/jdbc/mysql-connector-java-bin.jar 

RUN mkdir mysql_java_tmp && \
curl -L https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-$JDBC_VER.tar.gz --output mysql_java_tmp/mysql.tar.gz && \
mkdir -p $TEAMCITY_DATA_PATH/lib/jdbc && \
tar -vxzf mysql_java_tmp/mysql.tar.gz -C $TEAMCITY_DATA_PATH/lib/jdbc/ --wildcards "mysql-connector-java-*/mysql-connector-java-*.jar" --strip-components 1 && \
rm -rf mysql_java_tmp

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
