#!/usr/local/bin/bash

handle_update_data() {
   local -n req=$1
  #  tx_id=${req[tx_id]}
  #  if [[ $(repo_is_transaction_exists "$tx_id") -gt 0 ]];then 
  #   return
  #  fi
  # repo_create_transaction "$tx_id"
  # local -a node_ids
  # repo_retrieve_neighbour_node_ids node_ids
  # for i in "${node_ids[@]}";do
  #   req["target_port"]=$i
  #   client_request_update_data req
  # done
  pkg_snow_ball
}

handle_request_neighbour_nodes() {
  local -n req=$1
  local -a node_ids
  local -A response
  
  repo_retrieve_neighbour_node_ids node_ids
  response[target_port]=${req[from_port]}
  response[selection_id]=${req[selection_id]}
  response[from_port]=$node_id
  response[data]=${node_ids[*]}
  client_response_get_neighbour_nodes response
}


handle_response_neighbour_nodes() {
   local -n resp=$1
   selection_id="${resp[selection_id]}"
   data=(${resp[data]})
   IFS="," read -a dta <<<$data
   resp[data]=$(utils_join_strings data)
   resp[neighbour_id]=${resp[from_port]}
  repo_create_selection "$selection_id" resp
}