#!/usr/local/bin/bash

#? import
for f in ./utils/*.sh ./seed/*.sh ./configs/configs.sh ./internal/migrations/*.sh; do
  source $f
done

set -x

test_flow() {
  export MAX_NODES=10
  seed_all
}
seed_migrate_result
test_flow
