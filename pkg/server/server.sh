#!/usr/local/bin/bash

start_server() {
  node_id=$1
  port=$2
  export NODE_ID=$node_id
  export PORT=$port
  export DATA_PATH=./data/$NODE_ID.db

  echo "$node=node_id listening in port=$port"
  # while true; do
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
    $TESTING_EVENT)
      handle_test request response
      ;;
    esac
    local res_str=$(associative_array_to_string response)
    echo $res_str | nc localhost $from_port
    # done
  done
}

handler_new_block() {
  request=("$@")
  # snow_ball

}

handler_repo_retrieve_neighbour_nodes() {
  local -n req=$1
  local -n res=$2
  local -A neighbour_nodes
  repo_retrieve_neighbour_nodes neighbour_nodes
}

handler_connect_node() {
  request=("$@")
  # snow_ball
}