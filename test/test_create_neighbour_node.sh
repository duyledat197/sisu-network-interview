#!/usr/local/bin/bash
#? import
for f in ./utils/*.sh ./internal/**/*.sh; do
  source $f
done

set -x

test_flow() {
  amount=5
  declare -A data
  declare -A neighbour_nodes
  mock_neighbour_data data $amount
  repo_upsert_neighbour_nodes data $amount
  repo_retrieve_neighbour_nodes neighbour_nodes
}
migrate_data
test_flow
