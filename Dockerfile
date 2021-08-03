############################################################
# Dockerfile that contains SteamCMD
############################################################
FROM debian:buster-slim

LABEL maintainer="jeffreysmlinarik@gmail.com"
ARG PUID=1000

ENV USER steam
ENV HOMEDIR "/home/${USER}"
ENV STEAMCMDDIR "${HOMEDIR}/steamcmd"

# Install, update & upgrade packages
# Create user for the server
# This also creates the home directory we later need
# Clean TMP, apt-get cache and other stuff to make the image smaller
# Create Directory for SteamCMD
# Download SteamCMD
# Extract and delete archive
RUN set -x \
        && dpkg --add-architecture i386 \
        && apt-get update \
        && apt-get install -y --no-install-recommends --no-install-suggests \
                lib32stdc++6 \
                lib32gcc1 \
                wget \
                ca-certificates=20200601~deb10u2 \
                libsdl2-2.0-0:i386 \
                curl \
                locales \
        && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
        && dpkg-reconfigure --frontend=noninteractive locales \
        && useradd -u "${PUID}" -m "${USER}" \
        && su "${USER}" -c \
                "mkdir -p \"${STEAMCMDDIR}\" \
                && wget -qO- 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar xvzf - -C \"${STEAMCMDDIR}\" \
                && \"./${STEAMCMDDIR}/steamcmd.sh\" +quit \
                && mkdir -p \"${HOMEDIR}/.steam/sdk32\" \
                && ln -s \"${STEAMCMDDIR}/linux32/steamclient.so\" \"${HOMEDIR}/.steam/sdk32/steamclient.so\" \
                && ln -s \"${STEAMCMDDIR}/linux32/steamcmd\" \"${STEAMCMDDIR}/linux32/steam\" \
                && ln -s \"${STEAMCMDDIR}/steamcmd.sh\" \"${STEAMCMDDIR}/steam.sh\"" \
        && ln -s "${STEAMCMDDIR}/linux32/steamclient.so" "/usr/lib/i386-linux-gnu/steamclient.so" \
        && ln -s "${STEAMCMDDIR}/linux64/steamclient.so" "/usr/lib/x86_64-linux-gnu/steamclient.so" \
        && apt-get remove --purge -y \
                wget \
        && apt-get clean autoclean \
        && apt-get autoremove -y \
        && rm -rf /var/lib/apt/lists/*

# Switch to user
USER ${USER}

WORKDIR ${STEAMCMDDIR}

VOLUME ${STEAMCMDDIR}

RUN mkdir /home/steam/steamcmd/ark

COPY scripts/ark.sh /tmp

CMD cd /tmp && ./ark.sh