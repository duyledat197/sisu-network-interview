#!/usr/local/bin/bash
#? import
for f in ./utils/*.sh ./pkg/snow_ball.sh; do
  source $f
done

set -x

test_retrieve_graph() {
  num_node=5
  local -A sum_matrix
  local -A vertex
  local -A depth

  pkg_retrieve_graph sum_matrix vertex depth $num_node
}
