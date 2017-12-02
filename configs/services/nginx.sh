#!/usr/bin/env bash

NGINX_DIR=/tmp/tp-askmeme
PID_FILE="$NGINX_DIR/logs/nginx.pid"
CONF_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."

link_mimes() {
  orig_conf_dir="$(nginx -t 2>&1 |\
    egrep -o '/(.*)nginx\.conf' |\
    head -n1 |\
    sed 's/nginx.conf//')"
  rm -f "$CONF_DIR/mime.types"
  ln -s "$orig_conf_dir/mime.types" "$CONF_DIR/mime.types"
}

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

if [ ! -e "$CONF_DIR/mime.types" ]; then
  link_mimes
fi

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
  linkmimes)
    link_memes
    ;;
  *)
    echo "Usage: $0 {start|stop|restart|linkmimes}"
esac
