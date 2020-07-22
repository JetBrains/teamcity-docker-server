FROM ubuntu:18.04

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates fontconfig locales unzip \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

# JDK preparation start

ARG MD5SUM='7fab667aba936ef21928ce5d079e2e4a'
ARG JDK_URL='https://corretto.aws/downloads/resources/11.0.7.10.1/amazon-corretto-11.0.7.10.1-linux-x64.tar.gz'

RUN set -eux; \
    curl -LfsSo /tmp/openjdk.tar.gz ${JDK_URL}; \
    echo "${MD5SUM} */tmp/openjdk.tar.gz" | md5sum -c -; \
    mkdir -p /opt/java/openjdk; \
    cd /opt/java/openjdk; \
    tar -xf /tmp/openjdk.tar.gz --strip-components=1; \
    rm -rf /tmp/openjdk.tar.gz;

ENV JAVA_HOME=/opt/java/openjdk \
    PATH="/opt/java/openjdk/bin:$PATH"

RUN update-alternatives --install /usr/bin/java java ${JAVA_HOME}/bin/java 1 && \
    update-alternatives --set java ${JAVA_HOME}/bin/java && \
    update-alternatives --install /usr/bin/javac javac ${JAVA_HOME}/bin/javac 1 && \
    update-alternatives --set javac ${JAVA_HOME}/bin/javac

# JDK preparation end
##################################


ARG JDBC_VER=8.0.13

ENV TEAMCITY_DATA_PATH=/data/teamcity_server/datadir \
    TEAMCITY_DIST=/opt/teamcity \
    TEAMCITY_LOGS=/opt/teamcity/logs \
    TEAMCITY_TEMP=/opt/teamcity/temp \
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
RUN rm -rf $TEAMCITY_DIST/buildAgent && \
    rm -rf $TEAMCITY_DIST/temp

VOLUME $TEAMCITY_DATA_PATH \
       $TEAMCITY_LOGS \
       $TEAMCITY_TEMP

CMD ["/run-services.sh"]
