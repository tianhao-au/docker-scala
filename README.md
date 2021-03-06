# Scala Docker Image

[![](https://images.microbadger.com/badges/image/ysihaoy/scala.svg)](http://microbadger.com/images/ysihaoy/scala "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/ysihaoy/scala.svg)](http://microbadger.com/images/ysihaoy/scala "Get your own version badge on microbadger.com")

## Introduction
1. Dockerhub: [ysihaoy/scala](https://hub.docker.com/r/ysihaoy/scala/)
2. Docker image for Scala and SBT project with different version combinations

## Supported tags (combinations of Scala and SBT) and Dockerfile links
* 2.12.4-sbt-1.0.4, [Dockerfile](https://github.com/ysihaoy/docker-scala/blob/2.12.4-sbt-1.0.4/Dockerfile)

* 2.12.3-sbt-1.0.0, [Dockerfile](https://github.com/ysihaoy/docker-scala/blob/2.12.3-sbt-1.0.0/Dockerfile)

* 2.12.2-sbt-1.0.0.rc2, [Dockerfile](https://github.com/ysihaoy/docker-scala/blob/2.12.2-sbt-1.0.0.rc2/Dockerfile)

* 2.12.2-sbt-0.13.15, [Dockerfile](https://github.com/ysihaoy/docker-scala/blob/2.12.2-sbt-0.13.15/Dockerfile)

* 2.12.0-sbt-0.13.13, [Dockerfile](https://github.com/ysihaoy/docker-scala/blob/2.12.0-sbt-0.13.13/Dockerfile)

* 2.11.8-sbt-0.13.11, [Dockerfile](https://github.com/ysihaoy/docker-scala/blob/2.11.8-sbt-0.13.11/Dockerfile)

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
  FROM ysihaoy/scala:2.12.4-sbt-1.0.4

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
  sbt.version = 1.0.4
  ```

2. `build.sbt`
  ```
  scalaVersion := "2.12.4"
  ```

## You are an awesome Scala developer :-)
