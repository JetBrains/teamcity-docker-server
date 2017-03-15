#!/bin/bash

shutdown() {
    ${TEAMCITY_DIST}/bin/teamcity-server.sh stop
    exit 0
}

rm -f ${TEAMCITY_LOGS}/*.pid

trap 'shutdown' SIGTERM SIGINT SIGHUP

${TEAMCITY_DIST}/bin/teamcity-server.sh start

while [ ! -f ${TEAMCITY_DIST}/logs/teamcity-server.log ];
do
   echo -n "."
   sleep 1
done

tail -F ${TEAMCITY_DIST}/logs/teamcity-server.log &
wait
