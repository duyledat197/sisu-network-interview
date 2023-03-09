#!/usr/local/bin/bash

create_node() {
  node_id=$NODE_ID
  port=$PORT
  sqlite3 $RESULT_PATH <<EOF
INSERT INTO nodes (node_id, port) VALUES ('$node_id','$port');
EOF
}

get_node() {
  sqlite3 $RESULT_PATH <<EOF
SELECT node_id, port FROM nodes;
EOF
}
