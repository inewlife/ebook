FROM       docker.io/alpine:latest
MAINTAINER demo <juest a demo>

ENV TZ "Asia/Shanghai"

RUN echo "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.4/main" > /etc/apk/repositories

RUN apk add --update \
    bash \
    git \
    python \
    python-dev \
    py-pip \
    wget \
    build-base
RUN wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh |  sh /dev/stdin
