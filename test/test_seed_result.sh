#!/usr/local/bin/bash

#? import
for f in ./utils/*.sh ./seed/*.sh ./configs/configs.sh; do
  source $f
done

set -x

test_flow() {
  export MAX_NODES=10
  seed_result
  local -a nodes
  get_result_nodes nodes
  echo "${nodes[@]}"
}
seed_migrate_result
test_flow
