# 1709 images
docker build `
 -t teamcity-server:latest-windowsservercore-1709 `
 -f windowsservercore-1709/Dockerfile .

docker build `
 -t teamcity-server:latest-nanoserver-1709 `
 -f nanoserver-1709/Dockerfile .

# old images
docker build --isolation=hyperv `
 -t teamcity-server:latest-windowsservercore `
 -t teamcity-server:latest-windowsservercore-ltsc2016 `
 -f windowsservercore-ltsc2016/Dockerfile .

docker build --isolation=hyperv `
 -t teamcity-server:latest-nanoserver `
 -t teamcity-server:latest-nanoserver-sac2016 `
 -f nanoserver-sac2016/Dockerfile .