FROM ubuntu:22.04
LABEL maintainer="Cyb3rKo <niko@cyb3rko.de>"

RUN apt-get update && \
    apt-get install -y gnupg curl && \
    curl -fsSL https://pgp.mongodb.com/server-6.0.asc | \
    gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg --dearmor && \
    echo "deb [ arch=arm64,amd64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | \
    tee /etc/apt/sources.list.d/mongodb-org-6.0.list && \
    apt-get update && \
    apt-get --no-install-recommends install -y mongodb-org-tools && \
    echo "mongodb-org-tools hold" | dpkg --set-selections && \
    mkdir /backup && \
    apt-get install -y cron && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get remove -y gnupg curl && \
    apt-get autoremove -y

# Default: everyday at 00:00
ENV CRON_TIME="0 0 * * *"

ADD run.sh /run.sh
VOLUME ["/backup"]
CMD ["/run.sh"]
