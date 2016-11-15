FROM anapsix/alpine-java:jdk8
MAINTAINER Tianhao Li <ysihaoy@gmail.com>

ENV SBT_VERSION 0.13.13
ENV CHECKSUM 701ac8873b9f91c591c86cbd74b2b7057f9cfeeee374cc9bc07303243b6fb5e7

# Install sbt
RUN apk add --update bash curl openssl ca-certificates && \
  curl -L -o /tmp/sbt.zip \
    https://dl.bintray.com/sbt/native-packages/sbt/${SBT_VERSION}/sbt-${SBT_VERSION}.zip && \
  openssl dgst -sha256 /tmp/sbt.zip \
    | grep ${CHECKSUM} \
    || (echo 'shasum mismatch' && false) && \
  mkdir -p /opt/sbt && \
  unzip /tmp/sbt.zip -d /opt/sbt && \
  rm /tmp/sbt.zip && \
  chmod +x /opt/sbt/sbt-launcher-packaging-${SBT_VERSION}/bin/sbt && \
  ln -s /opt/sbt/sbt-launcher-packaging-${SBT_VERSION}/bin/sbt /usr/bin/sbt && \
  rm -rf /tmp/* /var/cache/apk/*

# Prebuild with sbt
COPY . /tmp/build/

# sbt sometimes failed because of network. retry 3 times.
RUN cd /tmp/build && \
  (sbt compile || sbt compile || sbt compile) && \
  (sbt test:compile || sbt test:compile || sbt test:compile) && \
  rm -rf /tmp/build

CMD ["sbt"]
