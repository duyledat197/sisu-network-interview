#!/usr/local/bin/bash

handle_update_data() {
   local -n request=$1
   tx_id=${request[tx_id]}
   if repo_is_transaction_exists "$tx_id" ;then 
    return
   fi
  repo_create_transaction "$tx_id"
  snow_ball
}

handle_request_neighbour_nodes() {
  local -n request=$1
  local -a data
  local -A response
  
  repo_retrieve_neighbour_node_ids data
  response[target_port]=${request[from_port]}
  response[selected_id]=${request[selected_id]}
  response[from_port]=${request[node_id]}
  response[data]=${data[*]}
  client_response_update_data response
}


handle_response_neighbour_nodes() {
   local -n response=$1
   neighbour_id=${response[from_port]}
   selected_id=${response[selected_id]}
   data=(${response[data]})
  local -A query_data
  for i in "${!data[@]}"
  do
    query_data[$i,selected_id]=$selected_id
    query_data[$i,neighbour_id]=$neighbour_id
    query_data[$i,selected_id]=${data[*]}
  done
  repo_create_selection query_data
}