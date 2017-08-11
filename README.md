## TeamCity Server Image Dockerfile

This project contains the Dockerfile and all necessary scripts to build the Docker image and run a TeamCity server inside the container.

You can pull the ready-to-use image from the Docker Hub repository
                                     
`docker pull jetbrains/teamcity-server`

If you need to build your own image, you need to perform the following:

1) Pull our base image and re-tag it

   ```
    docker pull jetbrains/teamcity-base
    docker tag jetbrains/teamcity-base teamcity-base
   ```
   You can use your own base image with the operation system of your choice and JAVA installed. TeamCity relies on the `JRE_HOME` environment variable. Just tag your own image with the `teamcity-base` tag.

2) Extract TeamCity.tar.gz of any version you'd like to use into  the `dist/teamcity` folder. In the same directory where the Dockerfile is placed, run

   ```
     mkdir dist
     tar zxf TeamCity-<version>.tar.gz -C dist/
     mv dist/TeamCity dist/teamcity
   ```
3) Run the `docker build` command:
   ```
    docker build -t teamcity-server
   ```

If you want to extend this image with your own setup scripts, you can place them in `/services` and the `run-services.sh`
script will run them before starting TeamCity server.  You can add your scripts with a `COPY` instruction in the Dockerfile,
or better yet, in a new image based on this one:

   ```Dockerfile
   FROM jetbrains/teamcity-server
   COPY my-special-setup-script.sh /services/
   ```

See our [detailed instructions](https://hub.docker.com/r/jetbrains/teamcity-server/) on how to use the image in the Docker Hub repository .
