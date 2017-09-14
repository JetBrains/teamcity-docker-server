FROM teamcity-server:latest-windowsservercore AS base

FROM teamcity-base:latest-nanoserver

ENV TEAMCITY_DIST="C:\TeamCity" \
    TEAMCITY_LOGS="C:\TeamCity\logs" \
    TEAMCITY_DATA_PATH="C:\ProgramData\JetBrains\TeamCity" \
    GIT_HOME="C:\Program Files\Git" \
    HG_HOME="C:\Program Files\Mercurial"

EXPOSE 8111

VOLUME $TEAMCITY_DATA_PATH \
       $TEAMCITY_LOGS

COPY --from=base $TEAMCITY_DIST $TEAMCITY_DIST
COPY --from=base $GIT_HOME $GIT_HOME
COPY --from=base $HG_HOME $HG_HOME

RUN setx /M PATH "%PATH%;%GIT_HOME%\cmd;%HG_HOME%"

CMD powershell C:/TeamCity/run-server.ps1