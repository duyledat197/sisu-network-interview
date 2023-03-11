#!/usr/local/bin/bash

source ./seed/repository.sh
seed_migrate_result() {
  cat ./seed/migrations.sql | sqlite3 "$RESULT_DB_PATH"
}

seed_init_node() {
  #? load parameters
  local node_id=$1
  local is_correct=$2
  local port=$node_id

  export NODE_ID=$node_id
  export DATA_PATH=./data/$node_id.db

  # TODO: each node present correct or not
  if $is_correct; then
    local -a result
    result=($(seed_get_result_nodes result))
    neighbour_nodes=($(utils_generate_random_some_numbers_from_array result $SAMPLE_SIZE))
  else
    neighbour_nodes=($(utils_generate_random_numbers $MAX_NODES))
  fi
  #* write data
  local -A data
  for i in "${!neighbour_nodes[@]}"; do
    data[$i,node_id]=$node_id
    data[$i,neighbour_id]=${neighbour_nodes[$i]}
    data[$i,position]=$((i + 1))
  done

  # working with db
  seed_create_neighbour_nodes data neighbour_nodes
  repo_create_node
  # repo_upsert_neighbour_nodes
}

seed_init_nodes() {
  random_nodes=($(utils_create_random_permutation_array "$MAX_NODES"))

  correct_from=$(($MAX_NODES * 70 / 100)) #TODO: for 70% nodes storage correct data
  for i in "${!random_nodes[@]}"; do
    is_correct=true
    if [[ i -gt $correct_from ]]; then
      is_correct=false
    fi
    seed_init_node "${random_nodes[$i]}" $is_correct
  done
}

seed_result() {
  export MAX_NODES=10
  result=($(utils_create_random_permutation_array "$MAX_NODES"))
  local -A nodes
  for i in "${!result[@]}"; do
    nodes[$i,node_id]=${result[$i]}
    nodes[$i,position]=$(($i + 1))
    nodes[$i,port]=$((9000 + ${result[$i]}))
  done
  seed_create_result_nodes nodes ${#result[@]}
}

seed_all() {
  seed_result
  seed_init_nodes
}
