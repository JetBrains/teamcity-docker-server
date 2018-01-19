FROM teamcity-server:latest-windowsservercore-1709 AS base

FROM teamcity-base:latest-nanoserver-1709

ENV TEAMCITY_DIST="C:\TeamCity" \
    TEAMCITY_LOGS="C:\TeamCity\logs" \
    TEAMCITY_DATA_PATH="C:\ProgramData\JetBrains\TeamCity"

EXPOSE 8111

VOLUME $TEAMCITY_DATA_PATH \
       $TEAMCITY_LOGS

COPY --from=base $TEAMCITY_DIST $TEAMCITY_DIST
COPY --from=base ["C:/Program Files/Git", "C:/Program Files/Git"]
COPY --from=base ["C:/Program Files/Mercurial", "C:/Program Files/Mercurial"]

# In order to set system PATH, ContainerAdministrator must be used
USER ContainerAdministrator
RUN setx /M PATH "%PATH%;C:\Program Files\Git\cmd;C:\Program Files\Mercurial"
USER ContainerUser

CMD pwsh C:/TeamCity/run-server.ps1