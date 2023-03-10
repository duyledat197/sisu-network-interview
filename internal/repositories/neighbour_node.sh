#!/usr/local/bin/bash

# set -x

declare -a neighbour_node_params=("node_id" "neighbour_id" "neighbour_port" "position")

repo_upsert_neighbour_nodes() {
  local -n dt=$1
  local size=$2
  for ((i = 0; i < $size; i++)); do
    dt[$i,node_id]=$NODE_ID
  done
  local values=$(get_values dt neighbour_node_params $size)
  sqlite3 $DATA_PATH <<EOF
INSERT INTO neighbour_nodes (node_id, neighbour_id, neighbour_port, position) 
VALUES $values
ON CONFLICT (node_id, neighbour_id) DO UPDATE 
SET position = EXCLUDED.position;
EOF
}

repo_retrieve_neighbour_nodes() {
  local index=0
  local -n resp=$1
  q=$(sqlite3 $DATA_PATH "SELECT neighbour_id FROM neighbour_nodes WHERE node_id = $node_id ORDER BY position ASC;")
  while read -r neighbour_id; do
    resp[$index]=$neighbour_id
    ((index++))
  done <<<$q
}

repo_retrieve_neighbour_node_ids() {
  local index=0
  local -n resp=$1
  q=$(sqlite3 $DATA_PATH "SELECT neighbour_id FROM neighbour_nodes WHERE node_id = $node_id ORDER BY position ASC;")
  while IFS='' read -r neighbour_id; do
    resp[$index]=$neighbour_id
    ((index++))
  done <<<$q
}
