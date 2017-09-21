FROM teamcity-base:latest-windowsservercore AS base

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Prepare TeamCity server distribution
ADD TeamCity-*.tar.gz /
RUN New-Item C:/TeamCity/webapps/ROOT/WEB-INF/DistributionType.txt -type file -force -value "docker" | Out-Null
COPY run-server.ps1 /TeamCity/run-server.ps1

# Install Git
RUN Invoke-WebRequest https://github.com/git-for-windows/git/releases/download/v2.14.1.windows.1/MinGit-2.14.1-64-bit.zip -OutFile git.zip; \
    Expand-Archive git.zip -DestinationPath $Env:ProgramFiles\Git ; \
    Remove-Item -Force git.zip

# Install Mercurial
RUN Invoke-WebRequest https://bitbucket.org/tortoisehg/files/downloads/mercurial-4.2.1-x64.msi -OutFile hg.msi; \
    Start-Process msiexec -Wait -ArgumentList /q, /i, hg.msi ; \
    Remove-Item -Force hg.msi

FROM teamcity-base:latest-windowsservercore

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