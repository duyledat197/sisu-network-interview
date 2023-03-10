#!/usr/local/bin/bash

main() {
  #? import
  for f in ./utils/*.sh ./internal/**/*.sh ./cmd/handler.sh; do
    source $f
  done

  new_node
  # migrate
  create_node
  start &
  snow_ball &
  wait
}
main
