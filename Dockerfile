FROM alpine:3.17.3
LABEL maintainer="Andy Pangaribuan <iam.pangaribuan@gmail.com>"

ENV TZ=Asia/Jakarta

WORKDIR /gearbox

RUN apk update

# curl
RUN apk add curl

# grpcurl
RUN curl -sSL "https://github.com/fullstorydev/grpcurl/releases/download/v1.8.6/grpcurl_1.8.6_linux_x86_64.tar.gz" | tar -xz -C /usr/local/bin

# micro
RUN curl -sSL "https://github.com/zyedidia/micro/releases/download/v2.0.11/micro-2.0.11-linux64-static.tar.gz" | tar -zx
RUN mv micro-2.0.11/micro /usr/local/bin/micro
RUN rm -rf micro-2.0.11

# vegeta
RUN curl -sSL "https://github.com/tsenart/vegeta/releases/download/v12.8.4/vegeta_12.8.4_linux_386.tar.gz" | tar -zx -C /usr/local/bin

# telnet
RUN apk add busybox-extras

# jq
RUN apk add jq

# make
RUN apk add make

# column
RUN apk add util-linux

RUN echo "alias task='/gearbox/.taskfile'" > /etc/profile.d/alias.sh

RUN <<EOF cat >> Makefile
ver=1.0.0

# enable make
all: help

help:
@cat Makefile | grep -B1 -E '^[a-zA-Z0-9_.-]+:.*' | grep -v -- -- | sed 'N;s/\n/###/' | sed -n 's/^#: \(.*\)###\(.*\):.*/\2###→ \1/p' | column -t -s '###' | sed 's/.*→ space.*//g'

#: show version
ver:
@echo "\$(ver)"

EOF

CMD ["tail", "-f", "/dev/null"]
