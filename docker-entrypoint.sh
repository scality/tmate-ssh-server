#!/bin/sh
set -e

if [ "${USE_PROXY_PROTOCOL:-0}" -eq "1" ]; then
  set -- -x "$@"
fi

if [ "${HAS_WEBSOCKET:-0}" -eq "1" ]; then
  set -- -w localhost "$@"
fi

if [ -n "${WEBSOCKET_HOSTNAME}" ]; then
  set -- -w "${WEBSOCKET_HOSTNAME}" "$@"
fi

if [ -n "${SSH_HOSTNAME}" ]; then
  set -- -h "${SSH_HOSTNAME}" "$@"
fi

SSH_PORT_LISTEN_DAEMON=${SSH_PORT_LISTEN_DAEMON:-2200}
SSH_PORT_LISTEN_CLIENT=${SSH_PORT_LISTEN_CLIENT:-2201}
SSH_PORT_ADVERTIZE=${SSH_PORT_ADVERTIZE:-${SSH_PORT_LISTEN_CLIENT}}

exec tmate-ssh-server -p ${SSH_PORT_LISTEN_DAEMON} -c ${SSH_PORT_LISTEN_CLIENT} -q ${SSH_PORT_ADVERTIZE} -k ${SSH_KEYS_PATH} "$@"
