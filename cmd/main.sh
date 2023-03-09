#!/usr/local/bin/bash

new_node() {
  export NODE_ID=$(uuid)
  export PORT=$(get_min_free_port)
  export DATA_PATH=./data/$NODE_ID.db
}

start() {
  node_id=$NODE_ID
  port=$PORT

  while true; do
    nc -l $port | while read req_str; do
      local -A request
      string_to_associative_array "$res_str" request
      #? request
      from_port=${request["from_port"]}
      event=${request["event"]}

      # handlers
      case $event in
      $NEW_BLOCK_EVENT)
        response=($(handle_new_block request))
        ;;
      $RETRIEVE_DATA_EVENT)
        response=($(handle_retrieve_neighbour_nodes request))
        ;;
      esac

      echo ${response[@]} | nc localhost $from_port
    done
  done
}

main() {
  #? import
  source ./utils/*.sh
  source ./pkg/*.sh
  source ./internal/**/*.sh
  source ./cmd/handler.sh

  new_node
  migrate
  start
}
main
