#!/usr/local/bin/bash

create_node() {
  node_id=$NODE_ID
  port=$PORT
  sqlite3 $RESULT_PATH <<EOF
INSERT INTO nodes (node_id, port) VALUES ('$node_id','$port');
EOF
}

get_node_port() {
  local -a resp
  local index=0
  node_id=$NODE_ID
  sqlite3 $RESULT_PATH "SELECT port FROM nodes WHERE node_id = '$node_id';" |
    while IFS='|' read -r port; do
      resp[$index]=$port
      ((index++))
    done
}
