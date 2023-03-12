#!/usr/local/bin/bash

#! tested
utils_input() {
  local -A input
  read -r str
  # input=$str
}

#! tested
utils_get_min_free_port() {
  local port=9000
  while :; do
    if ! netstat -atwn | grep -q "$port"; then
      break
    fi
    ((port++))
  done
  echo $port
}

 uuid() {
  echo $(uuidgen | tr -d - | tr -d '\n' | tr '[:upper:]' '[:lower:]'  | pbcopy && pbpaste && echo)
 }
