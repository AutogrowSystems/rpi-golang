FROM hypriot/rpi-alpine-scratch

RUN apk update
RUN apk add ca-certificates && update-ca-certificates

ENV GOLANG_VERSION 1.7.1
ENV GOLANG_URL https://storage.googleapis.com/golang/go$GOLANG_VERSION.linux-armv6l.tar.gz
ENV GOROOT /usr/local/go
RUN mkdir -p $GOROOT

RUN set -ex \
	&& apk add --no-cache --virtual .build-deps \
		bash \
		gcc \
		musl-dev \
		openssl \
                curl \
	\
	&& export GOROOT_BOOTSTRAP="$(go env GOROOT)"

RUN set -ex && curl -sSL "$GOLANG_URL" -o golang.tar.gz \
	&& tar -C /usr/local -xzf golang.tar.gz \
	&& rm golang.tar.gz

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

COPY go-wrapper /usr/local/bin
