## TeamCity Server Image Dockerfile

This project contains Dockerfile and all necessary scripts to build Docker image and run TeamCity server inside the container.

Ready-to-use image you can pull from Docker Hub Repository
                                     
```docker pull jetbrains/teamcity-server```

If you need to build your own image you need to perform the following action

1. Pull our base image and re-tag it 
```
docker pull jetbrains/teamcity-base
docker tag jetbrains/teamcity-base teamcity-base
```

You can use your own base image with operation system you like and JAVA installed. TeamCity relies on environment variable JRE_HOME. Just tag your own image with ```teamcity-base``` tag.

2. Extract TeamCity.tar.gz of any version you like to use into folder ```dist/teamcity``` folder. In the same directory where Dockerfile is place run
```
mkdir dist
tar zxf TeamCity-<version>.tar.gz -C dist/
mv dist/TeamCity dist/teamcity
```

3. Run ```docker build``` command
```
docker build -t teamcity-server .
```


Please check our detailed instruction how to use this image on [jetbrains/teamcity-server](https://hub.docker.com/r/jetbrains/teamcity-server/) Docker Hub Repository page.