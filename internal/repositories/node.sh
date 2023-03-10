#!/usr/local/bin/bash

repo_create_node() {
  node_id=$NODE_ID
  port=$PORT
  sqlite3 $RESULT_DB_PATH <<EOF
INSERT INTO nodes (node_id, port) VALUES ('$node_id','$port');
EOF
}

repo_get_node_port() {
  local node_id=$NODE_ID
  local index=0
  local -n resp=$1
  sqlite3 $RESULT_DB_PATH "SELECT port FROM nodes WHERE node_id = '$node_id';" | read -r port
  echo $port
}
