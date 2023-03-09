#!/usr/local/bin/bash

request_get_neighbour_nodes() {
  port=$PORT
  local -n req=$1
  local -n res=$2
  target_port=${req["target_port"]}

  req["event"]=$RETRIEVE_DATA_EVENT
  req_str=$(associative_array_to_string req)
  local res_str

  echo $req_str | nc localhost $target_port | while timeout 1s read res_str; do
    string_to_associative_array "$res_str" res
  done
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
