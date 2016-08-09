# Scala Docker Image

## Introduction
1. Dockerhub: [ysihaoy/scala](https://hub.docker.com/r/ysihaoy/scala/)
2. Docker image for Scala and SBT project with different versions

## How to use in your Scala SBT project
1. Sample of your minimal project structure

  ```
  your-scala-project
  │   build.sbt
  │   Dockerfile
  │
  ├───project
  |       build.properties
  |       plugins.sbt
  |
  └───src
      ├───main
      │   │   ...
      │
      └───test
  ```

2. Sample of your `Dockerfile` should be like:

  ```
  FROM ysihaoy/scala:2.11.8-sbt-0.13.11

  # caching dependencies
  COPY ["build.sbt", "/tmp/build/"]
  COPY ["project/plugins.sbt", "project/build.properties", "/tmp/build/project/"]
  RUN cd /tmp/build && \
    sbt compile && \
    sbt test:compile && \
    rm -rf /tmp/build

  # copy source code
  COPY . /root/app/
  WORKDIR /root/app
  RUN sbt compile && sbt test:compile

  CMD ["sbt"]
  ```

## Optimisation of the build
In order to have fast CI (continuous integration) build process, sample of your `project/build.properties` and `build.sbt` should be like:
1. `project/build.properties`
  ```
  sbt.version = 0.13.11
  ```
and

2. `build.sbt`
  ```
  scalaVersion := "2.11.8"
  ```

## Happy hacking Scala and Docker
