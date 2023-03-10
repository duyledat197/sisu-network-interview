#!/usr/local/bin/bash
#? import
for f in ./utils/*.sh ./internal/**/*.sh; do
  source $f
done

set -x

mock_neighbour_data() {
  local -n dt=$1
  local size=$2
  for ((i = 0; i < $size; i++)); do
    dt[$i, ${neighbour_node_params[0]}]=$NODE_ID
    dt[$i, ${neighbour_node_params[1]}]=$(($i + 1))
    dt[$i, ${neighbour_node_params[2]}]=$(get_min_free_port)
    dt[$i, ${neighbour_node_params[3]}]=$(($i + 1))
  done
}

test_flow() {
  amount=5
  declare -A data
  declare -A neighbour_nodes
  mock_neighbour_data data $amount
  upsert_neighbour_nodes data $amount
  retrieve_neighbour_nodes neighbour_nodes
}
migrate_data
test_flow
