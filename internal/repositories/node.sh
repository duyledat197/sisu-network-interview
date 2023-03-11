#!/usr/local/bin/bash

repo_create_node() {
  sqlite3 $DATA_PATH <<EOF
INSERT INTO nodes (node_id, port) VALUES ('$node_id','$port');
EOF
}

repo_get_node_port() {
  local index=0
  local -n resp=$1
  sqlite3 $DATA_PATH "SELECT port FROM nodes WHERE node_id = '$node_id';" | read -r port
  echo $port
}
