FROM mcr.microsoft.com/powershell:nanoserver-1903 AS base

SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Install JRE
RUN [Net.ServicePointManager]::SecurityProtocol = 'tls12, tls11, tls' ; \
    Invoke-WebRequest https://d3pxv6yz143wms.cloudfront.net/8.232.09.1/amazon-corretto-8.232.09.1-windows-x64-jre.zip -OutFile jre.zip; \
    Expand-Archive jre.zip -DestinationPath $Env:ProgramFiles\Java ; \
    Get-ChildItem $Env:ProgramFiles\Java | Rename-Item -NewName "OpenJDK" ; \
    Remove-Item -Force jre.zip

# Install tools from JDK
RUN [Net.ServicePointManager]::SecurityProtocol = 'tls12, tls11, tls' ; \
    Invoke-WebRequest https://d3pxv6yz143wms.cloudfront.net/8.232.09.1/amazon-corretto-8.232.09.1-windows-x64-jdk.zip -OutFile jdk.zip; \
    Expand-Archive jdk.zip -DestinationPath $Env:Temp\JDK ; \
    Get-ChildItem $Env:Temp\JDK | Rename-Item -NewName "OpenJDK" ; \
    ('jar.exe', 'jcmd.exe', 'jconsole.exe', 'jmap.exe', 'jstack.exe', 'jps.exe') | foreach { \
         Copy-Item $Env:Temp\JDK\OpenJDK\bin\$_ $Env:ProgramFiles\Java\OpenJDK\bin\ \
    } ; \
    Remove-Item -Force -Recurse $Env:Temp\JDK ; \
    Remove-Item -Force jdk.zip

# Install Git
RUN [Net.ServicePointManager]::SecurityProtocol = 'tls12, tls11, tls' ; \
    Invoke-WebRequest https://github.com/git-for-windows/git/releases/download/v2.19.1.windows.1/MinGit-2.19.1-64-bit.zip -OutFile git.zip; \
    Expand-Archive git.zip -DestinationPath $Env:ProgramFiles\Git ; \
    Remove-Item -Force git.zip

# Prepare TeamCity server distribution
ADD TeamCity-*.tar.gz /
RUN New-Item C:/TeamCity/webapps/ROOT/WEB-INF/DistributionType.txt -type file -force -value "docker-windows-1903" | Out-Null
COPY run-server.ps1 /TeamCity/run-server.ps1

# Workaround for https://github.com/PowerShell/PowerShell-Docker/issues/164
FROM mcr.microsoft.com/windows/nanoserver:1903

ENV ProgramFiles="C:\Program Files" \
    # set a fixed location for the Module analysis cache
    LOCALAPPDATA="C:\Users\ContainerAdministrator\AppData\Local" \
    PSModuleAnalysisCachePath="$LOCALAPPDATA\Microsoft\Windows\PowerShell\docker\ModuleAnalysisCache" \
    # Persist %PSCORE% ENV variable for user convenience
    PSCORE="$ProgramFiles\PowerShell\pwsh.exe"

COPY --from=base ["C:/Program Files/PowerShell", "C:/Program Files/PowerShell"]

# In order to set system PATH, ContainerAdministrator must be used
USER ContainerAdministrator
RUN setx /M PATH "%PATH%;%ProgramFiles%\PowerShell"
USER ContainerUser

# intialize powershell module cache
RUN pwsh -NoLogo -NoProfile -Command " \
    $stopTime = (get-date).AddMinutes(15); \
    $ErrorActionPreference = 'Stop' ; \
    $ProgressPreference = 'SilentlyContinue' ; \
    while(!(Test-Path -Path $env:PSModuleAnalysisCachePath)) {  \
        Write-Host "'Waiting for $env:PSModuleAnalysisCachePath'" ; \
        if((get-date) -gt $stopTime) { throw 'timout expired'} \
        Start-Sleep -Seconds 6 ; \
    }"

COPY --from=base ["C:/Program Files/Java/OpenJDK", "C:/Program Files/Java/OpenJDK"]
COPY --from=base ["C:/Program Files/Git", "C:/Program Files/Git"]

ENV JRE_HOME="C:\Program Files\Java\OpenJDK" \
    TEAMCITY_DIST="C:\TeamCity" \
    TEAMCITY_LOGS="C:\TeamCity\logs" \
    TEAMCITY_DATA_PATH="C:\ProgramData\JetBrains\TeamCity" \
    TEAMCITY_SERVER_MEM_OPTS="-Xmx2g -XX:ReservedCodeCacheSize=350m"


EXPOSE 8111

VOLUME $TEAMCITY_DATA_PATH \
       $TEAMCITY_LOGS

COPY --from=base $TEAMCITY_DIST $TEAMCITY_DIST

CMD pwsh C:/TeamCity/run-server.ps1

# In order to set system PATH, ContainerAdministrator must be used
USER ContainerAdministrator
RUN setx /M PATH "%PATH%;%JRE_HOME%\bin;C:\Program Files\Git\cmd"
USER ContainerUser