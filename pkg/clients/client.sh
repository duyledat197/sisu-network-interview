#!/usr/local/bin/bash

client_request_get_neighbour_nodes() {
  local -n req=$1
  target_port=${req[target_port]}
  from_port=${req[from_port]}
  req["event"]=$REQUEST_DATA_EVENT
  req_str=$(utils_associative_array_to_string req)

  echo "$req_str" | nc localhost "$target_port"
}

client_request_update_data() {
  local -n req=$1
  target_port=${req[target_port]}
  req["event"]=$UPDATE_DATA_EVENT
  req_str=$(utils_associative_array_to_string req)

  echo "$req_str" | nc localhost "$target_port"
}

client_response_update_neighbour_nodes() {
  local -n req=$1
  target_port=${req[target_port]}
  from_port=${req[from_port]}
  req["event"]=$RESPONSE_DATA_EVENT
  req_str=$(utils_associative_array_to_string req)

  echo "$req_str" | nc localhost "$target_port"
}
