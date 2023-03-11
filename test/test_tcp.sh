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
  request["event"]=$REQUEST_DATA_EVENT
  request["from_port"]=$client_port
  request["target_port"]=$target_port
  echo "client port: $client_port"
  while true; do
    local -A response
    client_request_get_neighbour_nodes request response

    nc -l $client_port | while read res_str; do
    echo $res_str
    utils_string_to_associative_array response "$res_str"
    echo "received message: $(print_associative_array response)"

    done
    sleep 3
  done
}

fake_server() {
  set -x
  server_port=9001
  node_id=1
  start_server $node_id $server_port
}

test_flow() {
  fake_client &
  fake_server &
  wait
}

test_flow
