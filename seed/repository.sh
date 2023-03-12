#!/usr/local/bin/bash

declare -a result_params=("node_id" "position" "port")

seed_create_result_nodes() {
  local -n dt=$1
  local size=$2
  values=$(utils_get_values dt result_params "$size")
  sqlite3 $RESULT_DB_PATH <<EOF
  INSERT INTO result_nodes (node_id, position, port) VALUES $values ON CONFLICT DO NOTHING;
EOF
}

seed_get_result_nodes() {
  local -a result
  local index=0
 query_result=$(sqlite3 "$RESULT_DB_PATH"  "SELECT node_id FROM result_nodes ORDER BY position ASC;")
  while IFS='' read -r id; do
    result[$index]=$id
    ((index++))
  done <<<$query_result
  echo "${result[@]}"
}

seed_create_neighbour_nodes() {
  local -n dt=$1
  local -n nb_nodes=$2
  sqlite3 -batch -separator $'\t' ./data/$node_id.db \
    "ATTACH DATABASE '${RESULT_DB_PATH}' AS db2;
    INSERT INTO neighbour_nodes (node_id, neighbour_id, neighbour_port) 
    SELECT 
      $node_id as node_id,
      rn.node_id as neighbour_id,
      rn.port as neighbour_port
    FROM db2.result_nodes as rn
    WHERE rn.node_id IN ($(utils_join_strings nb_nodes))
;"
  params=("node_id" "neighbour_id" "position")
  values=$(utils_get_values dt params ${#nb_nodes[@]})
  sqlite3 ./data/$node_id.db \
    "
    INSERT INTO neighbour_nodes (node_id, neighbour_id, position) 
    VALUES $values
    ON CONFLICT(node_id, neighbour_id) 
    DO UPDATE SET position=EXCLUDED.position;
    "
}
