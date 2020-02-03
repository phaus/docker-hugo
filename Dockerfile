FROM golang:alpine3.11
RUN apk --update add git libc-dev gcc g++ libstdc++ libgcc libsass-dev && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/cache/apk/*

ARG HUGO_VERSION=0.63.2

RUN mkdir $HOME/src \
    && cd $HOME/src \
    && git clone --branch v${HUGO_VERSION} https://github.com/gohugoio/hugo.git \
    && cd hugo \
    && CGO_ENABLED=1 GOOS=linux go install -a -ldflags "-linkmode external -extldflags -static" --tags extended

FROM alpine:3.11

LABEL maintainer="go-rr.org admins <admin@go-rr.org>"

RUN apk update \
    && apk add py-pygments \
    && rm -rf /var/cache/apk/*

COPY --from=0 $HOME/go/bin/hugo /usr/local/hugo

RUN chmod +x /usr/local/hugo && /usr/local/hugo version
