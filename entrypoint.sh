#!/bin/sh

if [ ! -z "${PRE_CONNECT_CHECK_CMD}" ]; then
  pre_check() {
    echo 'Checking if internet is available...' 1>&2
    echo "PRE_CONNECT_CHECK_CMD = ${PRE_CONNECT_CHECK_CMD}" 1>&2
    ${PRE_CONNECT_CHECK_CMD} 1>&2 && echo '0' || echo '1'
  }
  [ -z "${PRE_CONNECT_CHECK_MAX_RETRIES}" ] && PRE_CONNECT_CHECK_MAX_RETRIES=3
  RETRIES=0
  while [ "$(pre_check)" != '0' ] && [ ${RETRIES} -le ${PRE_CONNECT_CHECK_MAX_RETRIES} ]; do
    echo 'PRE_CONNECT_CHECK_CMD failed; not ready to connect yet...'
    sleep 1
    RETRIES=$((${RETRIES} + 1))
  done
  if [ ${RETRIES} -gt ${PRE_CONNECT_CHECK_MAX_RETRIES} ]; then
    echo 'Never got ready...'
    exit 1
  fi
fi

echo 'Connecting OpenVPN client now!'
/usr/sbin/openvpn $@
