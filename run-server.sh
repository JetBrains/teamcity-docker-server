#!/bin/bash

# Setting default values if variables not present
: ${TEAMCITY_DIST:=/opt/teamcity}
: ${TEAMCITY_LOGS:=${TEAMCITY_DIST}/logs}
: ${TEAMCITY_CONTEXT:=ROOT}

rm -f "${TEAMCITY_LOGS}/*.pid"

if [[ "$TEAMCITY_CONTEXT" != "ROOT" ]]; then
    current = "$(ls ${TEAMCITY_DIST}/webapps | head -1)"
    [[ "$current" != "$TEAMCITY_CONTEXT" ]] && mv "${TEAMCITY_DIST}/webapps/$current" "${TEAMCITY_DIST}/webapps/$TEAMCITY_CONTEXT"
fi

trap "'${TEAMCITY_DIST}/bin/teamcity-server.sh' stop; exit 0;" SIGTERM SIGINT SIGHUP

"${TEAMCITY_DIST}/bin/teamcity-server.sh" start

while [ ! -f "${TEAMCITY_DIST}/logs/teamcity-server.log" ];
do
   echo -n "."
   sleep 1
done

tail -F "${TEAMCITY_DIST}/logs/teamcity-server.log" &
wait
