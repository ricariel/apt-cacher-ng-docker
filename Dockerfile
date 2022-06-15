FROM debian:latest
LABEL org.label-schema.name="ricariel/apt-cacher-ng" \
      org.label-schema.vendor="fabrice.kirchner@casa-due-pur.de" \
      org.label-schema.docker.cmd="docker run --restart always -d -v apt-cacher-ng-vol:/var/cache/apt-cacher-ng:rw -p 3142:3142 ricariel/apt-cacher-ng" \
      org.label-schema.url="https://github.com/ricariel/apt-cacher-ng-docker" \
      org.label-schema.vcs-url="https://github.com/ricariel/apt-cacher-ng-docker.git" \
      org.label-schema.schema-version="1.0" \
			org.opencontainers.image.authors="fabrice.kirchner@casa-due-pur.de" \
      org.label-schema.vcs-type=Git \
      org.label-schema.maintainer="fabrice.kirchner@casa-due-pur.de"

ARG DEBIAN_FRONTEND=noninteractive
ENV LC_ALL C


RUN set -uex; \
    apt-get update -y; \
		apt-get upgrade -y; \
    apt-get install -y apt-cacher-ng curl; \
    mv /etc/apt-cacher-ng/acng.conf /etc/apt-cacher-ng/acng.conf.original; \
    ln -sf /dev/stdout /var/log/apt-cacher-ng/apt-cacher.log; \
    ln -sf /dev/stderr /var/log/apt-cacher-ng/apt-cacher.err; \
    apt-get clean all; \
    rm -rf /var/lib/apt/lists/*;

COPY files/* /etc/apt-cacher-ng/

EXPOSE 3142
VOLUME ["/var/cache/apt-cacher-ng"]

ENTRYPOINT ["/usr/sbin/apt-cacher-ng"]
CMD ["-c","/etc/apt-cacher-ng"]
