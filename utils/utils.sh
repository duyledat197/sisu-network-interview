#!/usr/local/bin/bash

#! tested
input() {
  local str
  read -p "input array: " str
  read -a $1 <<<"$str"
}

#! tested
get_min_free_port() {
  local port=9000
  while :; do
    if ! netstat -atwn | grep -q "$port"; then
      break
    fi
    ((port++))
  done
  echo $port
}
