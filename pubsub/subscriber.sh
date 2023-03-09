#!/usr/local/bin/bash

source ./internal/domain.sh

subscribe() {
  local port=$1
  nc -l $port | while read data; do
    echo "${data[@]}"
  done
}

# subscribe_topic() {
#   received_data="($@)"
#   topic=received_data["topic"]
#   node_id=$1
#   case $topic in
#   $REQUEST_VALIDATE_EVENT)
#     subscribe_request_validate $node_id ${received_data[@]}
#     ;;
#   $RESPONSE_VALIDATE_EVENT)
#     subscribe_response_validate $node_id ${received_data[@]}
#     ;;
#   *)
#     echo "Invalid option"
#     ;;
#   esac
# }

# subscribe_request_validate() {
#   received_data="($@)"
#   chosen_nodes=${received_data["chosen_nodes"]}
#   first=${received_data["first"]}
#   second=${received_data["second"]}
#   node_id=${received_data["target_node_id"]}
#   chain_id=${received_data["chain_id"]}
#   know_nodes=($(load_data $node_id))

#   if [[ ! -z $(get_chain_by_id $chain_id) ]]; then
#     return
#   fi

#   for id in ${know_nodes[@]}; do
#     local -A data
#     data["chosen_nodes"]=${chosen_nodes[@]}
#     data["chain_id"]=${received_data["chain_id"]}
#     data["first"]=$first
#     data["second"]=$second
#     data["node_id"]=$node_id
#     data["target_node_id"]=$id
#     publish_request_validate "${data[@]}"
#   done
#   sleep 2s

#   if printf '%s\n' "${chosen_nodes[@]}" | grep -xq "$node_id"; then
#     result=$(validate ${received_data[@]})
#     update_chain_by_id $node_id $chain_id ${result[@]}
#   fi

#   chain=($(get_chain_by_id $chain_id))
#   local -A data
#   data["target_node_id"]=${received_data["node_id"]}
#   data["node_id"]=$node_id
#   data["chain_id"]=$chain_id
#   data["result"]=${chain[@]}
#   publish_response_validate ${data[@]}
# }

# subscribe_response_validate() {
#   received_data="($@)"
#   node_id=$1
#   chain_id=${received_data["chain_id"]}
#   result=${received_data[@]}
#   update_chain_by_id $node_id $chain_id ${result[@]}
# }
