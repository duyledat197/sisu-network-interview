#!/usr/local/bin/bash

declare -a result_params=("node_id" "position" "port")

create_result_nodes() {
  local -n dt=$1
  local size=$2

  values=$(get_values dt result_params $size)
  echo $values
  sqlite3 $RESULT_PATH <<EOF
  INSERT INTO result_nodes (node_id, position, port) VALUES $values;
EOF
}

get_result_nodes() {
  local index=0
  local -n resp=$1
  resp=($(sqlite3 $RESULT_PATH "SELECT node_id FROM result_nodes ORDER BY position ASC;"))
}
