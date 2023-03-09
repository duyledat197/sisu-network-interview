#!/usr/local/bin/bash

create_result_nodes() {
  ids=("$@")
  neighbour_ids=$(join_strings ${ids[@]})
  sqlite3 $RESULT_PATH <<EOF
INSERT INTO result_nodes (node_ids) VALUES ($neighbour_ids);
EOF
}

get_result_nodes() {
  sqlite3 $RESULT_PATH <<EOF
SELECT node_ids FROM result_nodes;
EOF
}
