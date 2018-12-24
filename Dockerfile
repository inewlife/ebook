FROM alpine:latest
COPY simsun.ttc /usr/share/fonts/win/
# Download and install glibc
RUN apk add --update && \
    apk add --no-cache --upgrade \
    ca-certificates \
    gcc \
    g++ \
    make \
    curl \
    git

RUN apk add --update && \
    apk add --no-cache --upgrade \
    mesa-gl \
    python \
    qt5-qtbase-x11 \
    xdg-utils \
    libxrender \
    libxcomposite \
    xz \
    imagemagick \
    imagemagick-dev \
    msttcorefonts-installer \
    fontconfig && \
    update-ms-fonts && \
    fc-cache -f
RUN curl -Lo /etc/apk/keys/sgerrand.rsa.pub "https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub" && \
    curl -Lo glibc.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk" && \
    curl -Lo glibc-bin.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk" && \
    apk add glibc-bin.apk /var/glibc.apk && \
    /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib && \
    echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf


RUN curl -Lo linux-installer.py https://download.calibre-ebook.com/linux-installer.py


RUN  apk add glibc-bin.apk glibc.apk && \
    /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib && \
    echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
    rm -rf glibc.apk glibc-bin.apk /var/cache/apk/* && \
    chmod a+r /usr/share/fonts/win/simsun.ttc


ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/opt/calibre/lib
ENV PATH $PATH:/opt/calibre/bin

RUN cat linux-installer.py | python -c "import sys; main=lambda x,y:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main(install_dir='/opt', isolated=True)" && \
    rm -rf /tmp/* linux-installer.py


