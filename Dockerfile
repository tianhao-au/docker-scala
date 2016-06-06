FROM anapsix/alpine-java:jdk8

# Install sbt
RUN apk add --update bash curl openssl ca-certificates && \
  curl -L -o /tmp/sbt.zip \
    https://dl.bintray.com/sbt/native-packages/sbt/0.13.11/sbt-0.13.11.zip && \
  openssl dgst -sha256 /tmp/sbt.zip \
    | grep '2bd8149dab99d2fdde6a841fd637f468e887548ce10f42d80b34301bffe8aa4e' \
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

ENTRYPOINT ["sbt"]
CMD ["-help"]
