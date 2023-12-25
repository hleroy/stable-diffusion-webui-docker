FROM bash

RUN apk add parallel aria2
COPY . /docker
RUN chmod +x /docker/download.sh
ENTRYPOINT ["/docker/download.sh"]
