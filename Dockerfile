FROM linuxserver/deluge:latest

COPY packages/ /tmp

# For development.
ARG PIP_INDEX_URL
ARG PIP_TRUSTED_HOST

RUN \
    apk update && \
    apk add --no-cache --virtual=build-dependencies \
        alpine-sdk \
        py2-pip && \
    adduser -D build && \
    addgroup build abuild && \
    sudo -u build abuild-keygen -a -n && \
    chown -R build /tmp/libtorrent-rasterbar /tmp/deluge && \
    cd /tmp/libtorrent-rasterbar && \
    sudo -u build abuild -r && \
    cd /tmp/deluge && \
    rm /home/build/packages/tmp/*/APKINDEX.tar.gz && \
    sudo -u build abuild -r && \
    apk --allow-untrusted add \
        /home/build/packages/tmp/*/deluge-*-r0.apk \
        /home/build/packages/tmp/*/libtorrent-rasterbar-*-r0.apk && \
    pip install --egg YatfsRpc && \
    apk del --purge build-dependencies && \
    rm -rf /tmp/* && \
    rm -rf /home/build && \
    rm -rf /var/cache/apk/* && \
    deluser build

COPY root/ /
