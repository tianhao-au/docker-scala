FROM openjdk:8-jdk-alpine
MAINTAINER Tianhao Li <ysihaoy@gmail.com>

ENV SBT_VERSION 1.0.0
ENV CHECKSUM ecafdb3a965ee3dde3539f042624571409795c4a4fbfac5d7448503e21a37382

# Install sbt
RUN apk add --update bash curl openssl ca-certificates && \
  curl -L -o /tmp/sbt.zip \
    https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.zip && \
  openssl dgst -sha256 /tmp/sbt.zip \
    | grep ${CHECKSUM} \
    || (echo 'shasum mismatch' && false) && \
  mkdir -p /opt/sbt && \
  unzip /tmp/sbt.zip -d /opt/sbt && \
  rm /tmp/sbt.zip && \
  chmod +x /opt/sbt/sbt/bin/sbt && \
  ln -s /opt/sbt/sbt/bin/sbt /usr/bin/sbt && \
  rm -rf /tmp/* /var/cache/apk/*

# Prebuild with sbt
COPY . /tmp/build/

# sbt sometimes failed because of network. retry 3 times.
RUN cd /tmp/build && \
  (sbt compile || sbt compile || sbt compile) && \
  (sbt test:compile || sbt test:compile || sbt test:compile) && \
  rm -rf /tmp/build

CMD ["sbt"]
