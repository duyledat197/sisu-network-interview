#!/usr/local/bin/bash

#* import
source ./utils/utils.sh
source ./internal/repositories/*.sh
source ./internal/migration.sh

migrate_result() {
  sqlite3 $RESULT_PATH <<EOF
  DELETE FROM result_nodes;
    CREATE TABLE IF NOT EXISTS result_nodes (
      node_id TEXT,
      node_order INT
    );
EOF
}

seed_node() {
  #? load parameters
  node_id=$1
  is_correct=$2
  create_node_tables $node_id
  # echo "$node_id"
  result=($(get_result_node))

  # TODO: each node present correct or not
  if [[ $is_correct -eq true ]]; then
    know_nodes=($(generate_random_numbers_from_correct_array "${result[@]}"))
  else
    know_nodes=($(generate_random_numbers "$MAX_NODES"))
  fi
  #* write data
  for i in ${know_nodes[@]}; do
    insert_neighbour_node ${node_id} $i
  done
}

seed_result() {
  create_result_table
  result=($(create_random_permutation_array $MAX_NODES))
  for i in ${!result[@]}; do
    insert_result_node ${result[$i]} $i
  done
}

seed() {
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

seed
migrate_result
