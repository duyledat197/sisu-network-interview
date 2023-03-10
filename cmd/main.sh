#!/usr/local/bin/bash

new_node() {
  export PORT=$(get_min_free_port)
  export NODE_ID=$PORT
  export DATA_PATH=./data/$NODE_ID.db
}

start() {
  node_id=$NODE_ID
  port=$PORT

  while true; do
    nc -l $port | while read req_str; do
      local -A request
      local -A response
      string_to_associative_array "$res_str" request
      #? request
      from_port=${request["from_port"]}
      event=${request["event"]}

      # handlers
      case $event in
      $NEW_BLOCK_EVENT)
        handle_new_block request response
        ;;
      $RETRIEVE_DATA_EVENT)
        handle_retrieve_neighbour_nodes request response
        ;;
      esac
      local res_str=$(associative_array_to_string response)
      echo $res_str | nc localhost $from_port
    done
  done
}

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
