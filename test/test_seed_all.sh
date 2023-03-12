#!/usr/local/bin/bash

first_port=9000

#? import
for f in ./utils/*.sh \
 ./seed/*.sh \
  ./configs/configs.sh\
  ./internal/migrations/*.sh\
  ./internal/repositories/*.sh\
  ; do
  source "$f"
done

set -x

test_flow() {
  export MAX_NODES=10
  seed_all
}
seed_migrate_result
test_flow
