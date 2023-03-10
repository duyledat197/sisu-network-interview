#!/usr/local/bin/bash

declare -a result_params=("node_id" "position" "port")

create_result_nodes() {
  local -n dt=$1
  local size=$2

  values=$(get_values dt result_params $size)
  sqlite3 $RESULT_DB_PATH <<EOF
  INSERT INTO result_nodes (node_id, position, port) VALUES $values;
EOF
}

get_result_nodes() {
  local index=0
  local -n resp=$1
  resp=($(sqlite3 $RESULT_DB_PATH "SELECT node_id FROM result_nodes ORDER BY position ASC;"))
}

seed_neighbour_nodes() {
  local -n dt=$1
  local -n nb_nodes=$2
  sqlite3 -batch -separator $'\t' ./data/$node_id.db \
    "ATTACH DATABASE '${RESULT_DB_PATH}' AS db2;
    INSERT INTO neighbour_nodes (node_id, neighbour_id, neighbour_port) 
    SELECT 
      $node_id as node_id,
      node_id as neighbour_id,
      port as neighbour_port
    FROM db2.result_nodes as rn
    WHERE rn.node_id IN ($(join_strings ${nb_nodes[@]}))
;"
  params=("node_id" "neighbour_id" "position")
  local values=$(get_values dt params ${#nb_nodes[@]})
  sqlite3 ./data/$node_id.db \
    "
    INSERT INTO neighbour_nodes (node_id, neighbour_id, position) 
    VALUES $values
    ON CONFLICT(node_id, neighbour_id) 
    DO UPDATE SET position=EXCLUDED.position
    "
}
