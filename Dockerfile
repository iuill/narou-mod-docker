FROM ruby:3.4.8-bookworm AS builder

ENV DEBIAN_FRONTEND=noninteractive
ENV BUNDLE_PATH=/usr/local/bundle
ENV PATH=$BUNDLE_PATH/bin:$PATH

ARG NAROU_MOD_VERSION=latest
ARG AOZORAEPUB3_VERSION=latest

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        unzip; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

COPY build/scripts/install_narou_mod.sh /usr/local/bin/install_narou_mod.sh
COPY build/scripts/install_aozora_epub3.sh /usr/local/bin/install_aozora_epub3.sh
COPY build/scripts/install_kindlegen.sh /usr/local/bin/install_kindlegen.sh

RUN chmod +x /usr/local/bin/install_narou_mod.sh /usr/local/bin/install_aozora_epub3.sh /usr/local/bin/install_kindlegen.sh && \
    /usr/local/bin/install_narou_mod.sh "$NAROU_MOD_VERSION" && \
    /usr/local/bin/install_aozora_epub3.sh "$AOZORAEPUB3_VERSION" && \
    /usr/local/bin/install_kindlegen.sh

FROM ruby:3.4.8-slim-bookworm

ENV DEBIAN_FRONTEND=noninteractive
ENV BUNDLE_PATH=/usr/local/bundle
ENV PATH=$BUNDLE_PATH/bin:$PATH
ENV TZ=Asia/Tokyo
ENV HOME=/home/narou
ENV JAVA_HOME=/usr/lib/jvm/zulu21-ca-amd64
ENV PATH=$PATH:$JAVA_HOME/bin

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        extrepo \
        libjpeg62-turbo \
        tzdata; \
    extrepo enable zulu-openjdk; \
    apt-get update; \
    apt-get install -y --no-install-recommends zulu21-jre; \
    apt-get purge -y --auto-remove extrepo; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

RUN groupadd --gid 1000 narou && \
    useradd --uid 1000 --gid 1000 --create-home --home-dir $HOME narou

COPY --from=builder $BUNDLE_PATH $BUNDLE_PATH
COPY --from=builder /opt/AozoraEpub3 /opt/AozoraEpub3

COPY cmd/narou-mod-start.sh $HOME/narou-mod-start.sh

RUN chmod +x $HOME/narou-mod-start.sh && \
    chown -R narou:narou $HOME /opt/AozoraEpub3 && \
    sed -i 's/\r$//' $HOME/narou-mod-start.sh

USER narou
WORKDIR $HOME

EXPOSE 33000 33001

CMD ["./narou-mod-start.sh"]
