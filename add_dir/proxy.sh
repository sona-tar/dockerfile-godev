#!/bin/sh

PROXY="http://proxy.${DOMAIN}.co.jp:10080"
NOPROXY="localhost,.proxy.${DOMAIN}.co.jp,/var/run/docker.sock"

if [ ! -z "${DOMAIN}" ] ; then
    echo "Proxy : $PROXY"
    export ALL_PROXY="${PROXY}"
    export http_proxy="${ALL_PROXY}"
    export https_proxy="${ALL_PROXY}"
    export ftp_proxy="${ALL_PROXY}"
    export HTTP_PROXY="${ALL_PROXY}"
    export HTTPS_PROXY="${ALL_PROXY}"
    export FTP_PROXY="${ALL_PROXY}"

    export no_proxy="${NOPROXY}"
    export NO_PROXY="${NOPROXY}"
else
    echo "reset proxy"
    export ALL_PROXY="${PROXY}"
    unset ALL_PROXY
    unset http_proxy
    unset https_proxy
    unset ftp_proxy
    unset HTTP_PROXY
    unset HTTPS_PROXY
    unset FTP_PROXY

    unset no_proxy
    unset NO_PROXY
fi

