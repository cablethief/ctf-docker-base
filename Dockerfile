# FROM debian:bookworm
FROM ubuntu:focal

LABEL Maintainer="Michael Kruger <https://github.com/cablethief>"

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends cron supervisor busybox

# Copy our CRON scripts
COPY config/cron.d /etc/cron.d/
RUN chmod 0644 /etc/cron.d/*

RUN mkdir /workdir
WORKDIR /workdir

RUN mkdir /opt/web
COPY html/index.html /opt/web/index.html

# Copy our supervisor.d configs
COPY config/supervisor.d /etc/supervisor/conf.d

COPY config/supervisord.conf /etc/supervisor/supervisord.conf
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]


# RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
# 	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
# ENV LANG en_US.utf8