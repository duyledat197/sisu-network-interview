#!/usr/local/bin/bash

pkg_snow_ball() {
  #! load configs
  sample_size=$SAMPLE_SIZE
  node_id=$NODE_ID

 
  preference=$(seq 1 $MAX_NODES)

  consecutiveSuccesses=0
  while true; do
    #* create  a selection 
    selection_id=$(uuidgen)
    local -A neighbour_nodes
    repo_retrieve_neighbour_nodes neighbour_nodes
    chosen_nodes=($(utils_generate_random_some_numbers_from_array neighbour_nodes $sample_size))
    for chosen_node in "${chosen_nodes[@]}"
    do
      local -A request
      request[target_port]=$chosen_node
      request[selection_id]=$selection_id
      request[from_port]=$node_id
      client_request_get_neighbour_nodes request &
    done
    wait
    sleep 2
    local -a response_list
    repo_retrieve_selection_neighbour_nodes $selection_id response_list



    pref=$(pkg_retrieve_preference response_list)
    if [ ${#pref[@]} == 0 ]; then
      consecutiveSuccesses=0
      continue
    fi
    if utils_compare_array preference pref; then
      ((consecutiveSuccesses++))
    else
      preference=("${pref[@]}")
      consecutiveSuccesses=1
    fi
    if $consecutiveSuccesses >= $beta; then
      pkg_decide preference
      break
    fi
  done
}

pkg_retrieve_preference() {
  sample_size=$SAMPLE_SIZE
  alpha=$QUORUM_SIZE
  beta=$DECISION_THRESHOLD

  local -A sum_matrix
  local -n response_list=$1

  utils_init_square_matrix sum_matrix $MAX_NODES
  for i in "${!response_list[@]}"; do

    local -a nodes=(${response_list[@]})
    local -A matrix
    local -A preference
    utils_get_matrix_from_nodes nodes matrix
    utils_matrix_addition sum_matrix matrix
  done

  local -A result_matrix
  utils_init_square_matrix result_matrix $MAX_NODES
  for key in "${!sum_matrix[@]}"; do
    if ${sum_matrix[$key]} >= $alpha; then
      result_matrix[$key]=1
    fi
  done

  local -A depth
  pkg_retrieve_graph result_matrix depth

  declare -a preference
  declare -a mark
  index=0
  utils_init_array_by_length mark "$MAX_NODES"

  dfs() {
    u=$1
    if [[ ! -z ${mark[$u]} ]]; then
      echo "error: $u already exists"
      return
    fi
    mark[$u]=1
    preference[$index]=$u
    ((index++))
    for ((v = 0; v < depth[$u]; v++)); do
      depth[$v]=$((${depth[$v]} - ${result_matrix[$pos]}))
      if [ "${depth[$v]}" == 0 ]; then
        dfs $v
      fi
    done
  }
  for i in "${!depth[@]}"; do
    if [ ${depth[$i]} == 0 ]; then
      dfs $i
    fi
  done
  return "${preference[@]}"
}

#! tested
pkg_retrieve_graph() {
  local -n matrix=$1
  local -n dept=$2
  local size=$MAX_NODES

  utils_init_array_by_length dept "$size"
  for ((i = 0; i < "$size"; i++)); do
    for ((j = 0; j < "$size"; j++)); do
      if [ "${matrix[$i,$j]}" == 1 ]; then
        depth[$i]=$((depth[$i] + 1))
      fi
    done
  done
}

pkg_decide() {
  inform_port="$INFORM_PORT"
  local -n result=$1
  local -A data
  index=0
  for i in "${!result[@]}"; do
    val=${result[$i]}
    pos=$i
    data[$index,node_id]=$node_id
    data[$index,neighbour_id]=$val
    data[$index,position]=$pos
    ((index++))
  done

  repo_upsert_neighbour_nodes data $index

  if [[ ! -z $inform_port ]]; then
    echo "node=$node_id calculate done with result: ${result[*]}" | nc localhost "$inform_port"
  fi
}
