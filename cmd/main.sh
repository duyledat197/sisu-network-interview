#!/usr/local/bin/bash

 #? import
  for f in ./configs/*.sh \
  ./utils/*.sh \
  ./internal/**/*.sh \
  \
  ./pkg/**/*.sh; do
    source $f
  done
  
main() { 
  migrate_data
  start_server
}
main
