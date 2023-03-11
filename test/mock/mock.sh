#!/usr/local/bin/bash

mock_neighbour_data() {
  local -n dt=$1
  local size=$2
  for ((i = 0; i < $size; i++)); do
    dt[$i,${neighbour_node_params[0]}]=$NODE_ID
    dt[$i,${neighbour_node_params[1]}]=$(($i + 1))
    dt[$i,${neighbour_node_params[2]}]=$((9000 + i))
    dt[$i,${neighbour_node_params[3]}]=$(($i + 1))
  done
}
