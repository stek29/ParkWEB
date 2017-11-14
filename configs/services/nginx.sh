#!/usr/bin/env bash

NGINX_DIR=/tmp/tp-askmeme
PID_FILE="$NGINX_DIR/logs/nginx.pid"
CONF_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."

start_nginx() {
  if [ ! -e "$PID_FILE" ]; then
    mkdir -p "$NGINX_DIR/logs"
    nginx -p "$NGINX_DIR" -c "$CONF_DIR/nginx.conf"
  fi
}

stop_nginx() {
  if [ -e "$PID_FILE" ]; then
    kill $(cat "$PID_FILE")
    rm "$PID_FILE"
  fi
}

case "$1" in
  start)
    start_nginx
    ;;
  stop)
    stop_nginx
    ;;
  restart)
    stop_nginx
    start_nginx
    ;;
  *)
    echo "Usage: $0 {start|stop|restart}"
esac
