#!/usr/local/bin/bash

 #? import
  for f in ./configs/*.sh \
  ./utils/*.sh \
  ./internal/**/*.sh \
  \
  ./pkg/**/*.sh; do
    source $f
  done


test_flow() {
  mkdir -p logs
  for i in $(seq 1 200); do
    export MAX_NODES=200
    export SAMPLE_SIZE=20   # 70% of max nodes
    export QUORUM_SIZE=14 # 70% of sample size
    export DECISION_THRESHOLD=20
    export INFORM_PORT=10101
    start_server "$i" "$i" &
  done
  wait
}

test_flow
