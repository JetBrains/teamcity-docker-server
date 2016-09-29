#!/bin/bash

shutdown() {
    ${TEAMCITY_DIST}/bin/teamcity-server.sh stop
}

rm -f ${TEAMCITY_LOGS}/*.pid

trap 'shutdown' SIGTERM SIGINT SIGHUP

/bin/bash -c  "${TEAMCITY_DIST}/bin/teamcity-server.sh run"