#!/usr/local/bin/bash

source ./seed/repository.sh
seed_migrate_result() {
  cat ./seed/migrations.sql | sqlite3 "$RESULT_DB_PATH"
}

seed_init_node() {
  # set -x
  #? load parameters
  local node_id=$1
  local is_correct=$2
  local port=$node_id
  # set +x
  export NODE_ID=$node_id
  export DATA_PATH=./data/$node_id.db

  # TODO: each node present correct or not
  if $is_correct; then
    result=($(seed_get_result_nodes result))
    neighbour_nodes=($(utils_generate_random_some_numbers_from_array result))
  else
    neighbour_nodes=($(utils_generate_random_numbers $MAX_NODES))
  fi
  #* write data
  local -A data
  for i in "${!neighbour_nodes[@]}"; do
    data[$i,node_id]=$(($first_port + $i))
    data[$i,neighbour_id]=${neighbour_nodes[$i]}
    data[$i,position]=$((i + 1))
  done

  # working with db
  migrate_data
  seed_create_neighbour_nodes data neighbour_nodes
  repo_create_node
  # repo_upsert_neighbour_nodes
}

seed_init_nodes() {
  random_nodes=($(utils_create_random_permutation_array $first_port "$MAX_NODES"))
  # echo ${random_nodes[@]}
  correct_from=$(($MAX_NODES * 90 / 100)) #TODO: for 70% nodes storage correct data
  for i in "${!random_nodes[@]}"; do
    is_correct=true
    if [[ i -gt $correct_from ]]; then
      is_correct=false
    fi
    seed_init_node "${random_nodes[$i]}" $is_correct &
  done
  wait
}

seed_result() {
  seed_migrate_result
  result=($(utils_create_random_permutation_array $first_port "$MAX_NODES"))
  local -A nodes
  for i in "${!result[@]}"; do
    nodes[$i,node_id]=${result[$i]}
    nodes[$i,position]=$(($i + 1))
    nodes[$i,port]=${result[$i]}
  done
  seed_create_result_nodes nodes ${#result[@]}
}

seed_all() {
  # set -x
  seed_result
  seed_init_nodes
  # set +x
}
