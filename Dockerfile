FROM alpine:latest

COPY watch.sh /

RUN apk add --purge --no-cache --update inotify-tools bash && \
    chmod 755 /watch.sh

CMD ["sh", "-c", "/watch.sh"]
