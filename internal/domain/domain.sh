#!/usr/local/bin/bash

#? import
source ./utils/*.sh
source ./configs/*.sh

########################################################################

subscribe_ping() {
  received_data="($@)"
  node_id=${received_data["target_node_id"]}
  tx_id=${received_data["tx_id"]}
  chosen_nodes=${received_data["chosen_nodes"]}
  #? if transaction already execute
  if [[ ! -z $(get_transaction $node_id $tx_id $PING_EVENT) ]]; then
    return
  fi
  create_transaction $node_id $tx_id $PING_EVENT
  neighbour_nodes=($(get_neighbour_nodes $node_id))

  for neighbour_node_id in ${neighbour_nodes[@]}; do
    local -A data
    data["target_node_id"]=$neighbour_node_id
    data["node_id"]=$node_id
    data["tx_id"]=$tx_id
    data["chosen_nodes"]=${chosen_nodes[@]}
    ping ${data[@]}

    if printf '%s\n' "${chosen_nodes[@]}" | grep -xq "$node_id"; then
      data["neighbour_nodes"]=${neighbour_nodes[@]}
      data["from_node_id"]=$node_id
      publish_data ${data[@]}
    fi
  done
  # wait
}

subscribe_publish_data() {
  received_data="($@)"
  from_node_id=${received_data["from_node_id"]}
  node_id=${received_data["target_node_id"]}
  tx_id=${received_data["tx_id"]}
  chosen_nodes=${received_data["chosen_nodes"]}
  neighbour_nodes=${received_data["neighbour_nodes"]}
  #? if transaction already process
  if [[ ! -z $(get_transaction $node_id $tx_id $PUBLISH_DATA_EVENT) ]]; then
    return
  fi
  create_transaction $node_id $tx_id $PUBLISH_DATA_EVENT
  if printf '%s\n' "${chosen_nodes[@]}" | grep -xq "$node_id"; then
    for ((i = 0; i < ${!neighbour_nodes[@]}; i++)); do
      for ((j = 0; j < i; j++)); do
        local -A data
        data["node_id"]=$node_id
        data["from_node_id"]=$from_node_id
        data["tx_id"]=$tx_id
        data["first"]=${neighbour_nodes[$i]}
        data["second"]=${neighbour_nodes[$j]}
        create_comparison ${data[@]}
      done
    done

    return
  else
    for neighbour_node_id in ${neighbour_nodes[@]}; do
      local -A data
      data["node_id"]=$node_id
      data["target_node_id"]=$neighbour_node_id
      data["tx_id"]=$tx_id
      data["chosen_nodes"]=${chosen_nodes[@]}
      data["neighbour_nodes"]=${neighbour_nodes[@]}
      data["from_node_id"]=$from_node_id
      publish_data ${received_data[@]}
    done
  fi

}

#############
