FROM teamcity-server:latest-windowsservercore AS base

FROM teamcity-base:latest-nanoserver

ENV TEAMCITY_DIST="C:\TeamCity" \
    TEAMCITY_LOGS="C:\TeamCity\logs" \
    TEAMCITY_DATA_PATH="C:\ProgramData\JetBrains\TeamCity"

EXPOSE 8111

VOLUME $TEAMCITY_DATA_PATH \
       $TEAMCITY_LOGS

COPY --from=base $TEAMCITY_DIST $TEAMCITY_DIST
COPY --from=base ["C:/Program Files/Git", "C:/Program Files/Git"]
COPY --from=base ["C:/Program Files/Mercurial", "C:/Program Files/Mercurial"]

RUN setx /M PATH "%PATH%;C:\Program Files\Git\cmd;C:\Program Files\Mercurial"

CMD powershell C:/TeamCity/run-server.ps1