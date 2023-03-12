#!/usr/local/bin/bash

client_request_get_neighbour_nodes() {
  local -n request_1=$1
  target_port=${request_1[target_port]}
  from_port=${request_1[from_port]}
  request_1["event"]=$REQUEST_DATA_EVENT
  req_str=$(utils_associative_array_to_string req)

  echo "$req_str" | nc localhost "$target_port"
}

client_request_update_data() {
  local -n request_2=$1
  target_port=${request_2[target_port]}
  request_2["event"]=$UPDATE_DATA_EVENT
  req_str=$(utils_associative_array_to_string req)

  echo "$req_str" | nc localhost "$target_port"
 
}

client_response_get_neighbour_nodes() {
  local -n req=$1
  target_port=${req[target_port]}
  from_port=$port
  req["event"]=$RESPONSE_DATA_EVENT
  req_str=$(utils_associative_array_to_string req)
  # set -x
  echo "$req_str" | nc localhost "$target_port"
  # set +x
}
