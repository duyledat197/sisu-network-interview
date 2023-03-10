#!/usr/local/bin/bash

client_request_get_neighbour_nodes() {
  local -n req=$1
  local -n res=$2
  target_port=${req["target_port"]}
  from_port=${req["from_port"]}
  req["event"]=$RETRIEVE_DATA_EVENT
  req_str=$(utils_associative_array_to_string req)
  local res_str

  echo $req_str | nc localhost $target_port
}

# request_new_block() {
#   port=$PORT
#   request=("$@")
#   target_port=${request["target_port"]}

#   request["event"]=$NEW_BLOCK_EVENT

#   echo $port | nc localhost $target_port | while timeout 1s read response; do
#     echo "${response[@]}"
#   done
# }
