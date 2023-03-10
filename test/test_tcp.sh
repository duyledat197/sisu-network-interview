#!/usr/local/bin/bash

#? import
for f in ./configs/*.sh \
  ./utils/*.sh \
  ./internal/repositories/*.sh \
  \
  ./pkg/**/*.sh; do # ./seed/*.sh \
  source $f
done

fake_client() {
  client_port=9000
  target_port=9001
  local -A request
  request["event"]=$RETRIEVE_DATA_EVENT
  request["from_port"]=$client_port
  request["target_port"]=$target_port
  echo "client port: $client_port"
  while true; do

    utils_input input
    local -A response
    client_request_get_neighbour_nodes request response
    echo "received message: $response"
  done
}

fake_server() {
  server_port=9001
  node_id=$server_port
  start_server $node_id $server_port
}

test_flow() {
  fake_client &
  fake_server &>./out_server.log 2>&1
  wait
}

test_flow
