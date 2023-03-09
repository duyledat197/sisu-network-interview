#!/usr/local/bin/bash

source ./configs/configs.sh

publish() {
  local data=("$@")
  local node_addr=${data["node_addr"]}
  local target_addr=${data["target_addr"]}
  echo "${data[@]}" | nc $target_addr $node_addr
}

ping() {
  data=("$@")
  data["topic"]=$PING_EVENT
  publish ${data[@]}
}

publish_data() {
  data=("$@")
  data["topic"]=$PUBLISH_DATA_EVENT
  publish ${data[@]}
}
