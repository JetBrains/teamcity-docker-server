
[![official JetBrains project](http://jb.gg/badges/official-plastic.svg)](https://confluence.jetbrains.com/display/ALL/JetBrains+on+GitHub)
## TeamCity Server Image Dockerfile

This project contains the Dockerfiles and all necessary scripts to build the Linux and Windows Docker images and run a TeamCity server inside the container.

You can pull the ready-to-use image from the Docker Hub repository
                                     
`docker pull jetbrains/teamcity-server`

If you need to build your own image, you need to perform the following:

1) Create your own base image with the operation system of your choice and Java 8 installed.
   Export `JRE_HOME` environment variable since TeamCity requires it for start.
   [Build and tag it](https://docs.docker.com/engine/reference/commandline/build/#tag-an-image--t) with the `teamcity-base` tag.

   Note: Use `teamcity-base:latest-windowsservercore` and `teamcity-base:latest-nanoserver` tags for Windows images.

2) On Unix extract `TeamCity.tar.gz` of any version you'd like to use into  the `dist/teamcity` folder. In the same directory where the Dockerfile is placed, run

   ```
     mkdir dist
     tar zxf TeamCity-<version>.tar.gz -C dist/
     mv dist/TeamCity dist/teamcity
   ```
   
   On Windows just put `TeamCity.tar.gz` into the repository root.
   
3) Run the `docker build` command:
   ```
    docker build -t teamcity-server
   ```
   
   On Windows just execute `build.ps1` powershell script.

If you want to extend this image with your own setup scripts, you can place them in `/services` and the `run-services.sh`
script will run them before starting TeamCity server.  You can add your scripts with a `COPY` instruction in the Dockerfile,
or better yet, in a new image based on this one:

   ```Dockerfile
   FROM jetbrains/teamcity-server
   COPY my-special-setup-script.sh /services/
   ```

See our [detailed instructions](https://hub.docker.com/r/jetbrains/teamcity-server/) on how to use the image in the Docker Hub repository .
