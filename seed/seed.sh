#!/usr/local/bin/bash

migrate_result() {
  cat ./seed/migrations.sql | sqlite3 $RESULT_PATH
}

seed_node() {
  #? load parameters
  local node_id=$1
  local is_correct=$2

  export $NODE_ID=$node_id
  export $MAX_NODE=10
  # new_node
  # migrate
  # create_node

  # TODO: each node present correct or not
  if $is_correct; then
    local -a result
    get_result_nodes result
    know_nodes=($(generate_random_numbers_from_correct_array ${result[@]}))
  else
    know_nodes=($(generate_random_numbers "$MAX_NODES"))
  fi
  #* write data
  local -A data
  for i in ${!know_nodes[@]}; do
    data[$i, "neighbour_id"]=${know_nodes[$i]}
    data[$i, "neighbour_id"]=${know_nodes[$i]}
  done
  upsert_neighbour_nodes
}

seed_result() {
  local result=($(create_random_permutation_array $MAX_NODES))
  local -A nodes
  for i in ${!result[@]}; do
    nodes[$i, "node_id"]=${result[$i]}
    nodes[$i, "position"]=$(($i + 1))
    nodes[$i, "port"]=$(get_min_free_port)

  done
  create_result_nodes nodes ${#result[@]}
}

seed_all() {
  seed_result
  nodes=($(create_random_permutation_array $MAX_NODES))
  echo "${nodes[@]}"
  correct_from=$(($MAX_NODES * 55 / 100)) #TODO: for 55% consensus
  for i in "${!nodes[@]}"; do
    is_correct=true
    if [[ i -gt $correct_from ]]; then
      is_correct=false
    fi
    seed_node ${nodes[$i]} $is_correct
  done
}
