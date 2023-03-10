#!/usr/local/bin/bash


start_server() {
  node_id=$1
  port=$2
  inform_port=$INFORM_PORT
  exec > logs/$node_id.log 2>&1
  if [[ ! -z $DEBUG ]]; then
    # set -x
   set +x 
  fi
  export NODE_ID=$node_id
  export PORT=$port
  export DATA_PATH=./data/$NODE_ID.db

  echo "node_id=$node_id listening in port=$port inform_port=$inform_port"

  while true; do
    # echo $port
    nc -l "$port" | while read -r req_str; do
      local -A request
      local -A response
      # echo "received message: $req_str"
      utils_string_to_associative_array request "$req_str"
      #? request
      from_port=${request[from_port]}
      event=${request["event"]}

      #* handlers
      case $event in
      "$UPDATE_DATA_EVENT")
        handle_update_data request &
        ;;
      "$REQUEST_DATA_EVENT")
        handle_request_neighbour_nodes request &
        ;;
      "$RESPONSE_DATA_EVENT")
        handle_response_neighbour_nodes request &
        ;;
      esac
    done
    # echo "done"
  done
}
