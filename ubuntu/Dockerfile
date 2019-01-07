FROM adoptopenjdk/openjdk8:x86_64-ubuntu-jdk8u192-b12
MAINTAINER Kateryna Shlyakhovetska <shkate@jetbrains.com>
MAINTAINER Vladislav Rassokhin <vladislav.rassokhin@jetbrains.com>

ARG JDBC_VER=8.0.13

ENV TEAMCITY_DATA_PATH=/data/teamcity_server/datadir \
    TEAMCITY_DIST=/opt/teamcity \
    TEAMCITY_LOGS=/opt/teamcity/logs

EXPOSE 8111
LABEL dockerImage.teamcity.version="latest" \
      dockerImage.teamcity.buildNumber="latest"

# Install Perforce Key
RUN apt-get update && \
    apt-get install -y gnupg && \
    . /etc/os-release && \
    apt-key adv --fetch-keys https://package.perforce.com/perforce.pubkey && \
    mkdir -p /etc/apt/sources.list.d && \
    echo "deb http://package.perforce.com/apt/$ID $VERSION_CODENAME release" > /etc/apt/sources.list.d/perforce.list

RUN apt-get update && \
    apt-get install -y \
    git \
    mercurial \
    ca-certificates \
    helix-cli && \
# It would be nice to use the version in the Ubuntu repo, but its not compatible with MySQL 8.0
    #libmysql-java && \ 
    apt-get clean all

# Restore this if the libmysql-java package is updated
#RUN mkdir -p $TEAMCITY_DATA_PATH/lib/jdbc && \
#    ln -s /usr/share/java/mysql.jar $TEAMCITY_DATA_PATH/lib/jdbc/mysql-connector-java-bin.jar 

RUN mkdir mysql_java_tmp && \
curl -L https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-$JDBC_VER.tar.gz --output mysql_java_tmp/mysql.tar.gz && \
mkdir -p $TEAMCITY_DATA_PATH/lib/jdbc && \
tar -vxzf mysql_java_tmp/mysql.tar.gz -C $TEAMCITY_DATA_PATH/lib/jdbc/ --wildcards "mysql-connector-java-*/mysql-connector-java-*.jar" --strip-components 1 && \
rm -rf mysql_java_tmp

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
