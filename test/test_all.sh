#!/usr/local/bin/bash

#? import
for f in ./configs/*.sh \
  ./utils/*.sh \
  ./internal/**/*.sh \
  ./seed/seed.sh \
  ./pkg/**/*.sh; do
  source $f
done

export MAX_NODES=50
export SAMPLE_SIZE=10 # 70% of max nodes
export QUORUM_SIZE=7 # 70% of sample size
export DECISION_THRESHOLD=10
export INFORM_PORT=10101

first_port=9000

# export DEBUG=true

inform_server() {
  while true; do
    nc -l "$INFORM_PORT" | while read -r req_str; do
      echo "done from: $req_str"
    done
  done
}

inform_client() {
  # set -x
  random_port=$(("$RANDOM" % "$MAX_NODES" + $first_port))
  local -A req
  req[target_port]=$random_port
  req[tx_id]=$(uuid)
  client_request_update_data req
  echo "send update data to $random_port"
}

test_flow() {
  mkdir -p logs
  for ((i=first_port; i < $((first_port+MAX_NODES));i++)); do
    start_server "$i" "$i" &
  done
  inform_server &
  inform_client
  wait
}
seed_all
test_flow
