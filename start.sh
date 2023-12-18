#!/bin/bash

NODE_PORT="3000"

# Start supervisord and services
if [[ -z "${NODE_MODE}" ]]; then
  NODE_MODE="prod"
else
  NODE_MODE="${NODE_MODE}"
fi

# Create Nginx pid
mkdir -p /run/nginx

/usr/bin/supervisord -n -c /etc/supervisord.conf
