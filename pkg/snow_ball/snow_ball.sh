#!/usr/local/bin/bash

pkg_snow_ball() {
  # set -x
  #! load configs
  sample_size="$SAMPLE_SIZE" 
  preference=($(seq 1 "$MAX_NODES"))
  consecutiveSuccesses=0
  utils_init_array_by_length consecutiveSuccesses "$MAX_NODES"
  while true; do
    #* create  a selection 
    selection_id=$(uuid)
    local -A neighbour_nodes
    repo_retrieve_neighbour_nodes neighbour_nodes
    chosen_nodes=($(utils_generate_random_some_numbers_from_array neighbour_nodes "$sample_size"))
    for chosen_node in "${chosen_nodes[@]}"
    do
      local -A request
      request[target_port]=$chosen_node
      request[selection_id]=$selection_id
      request[from_port]="$node_id"
      client_request_get_neighbour_nodes request &
    done
    wait
    sleep 5
    local -a response_list
    repo_retrieve_selection_neighbour_nodes "$selection_id" response_list
    # print_associative_array response_list
    local -a pref 
    local -a res_pref
    pkg_retrieve_preference response_list pref res_pref

    if [[ $(pkg_check_condition res_pref) ]]; then 
      consecutiveSuccesses=0
      continue
    fi

    if utils_compare_array preference pref; then
      ((consecutiveSuccesses++))
    else
      preference=("${pref[@]}")
      consecutiveSuccesses=1
    fi
    if [[ $consecutiveSuccesses -ge "$beta" ]]; then
      pkg_decide preference
      break
    fi
  done
}

pkg_retrieve_preference() {
  alpha=$QUORUM_SIZE
  beta=$DECISION_THRESHOLD

  local -A sum_matrix
  local -n res_list=$1
  local -n res_pref=$2

  utils_init_square_matrix sum_matrix "$MAX_NODES"
  echo "pkg_retrieve_preference"
  for i in "${!res_list[@]}"; do

    nodes=(${res_list[@]})
    local -A matrix
    utils_get_matrix_from_nodes nodes matrix
    utils_add_square_matrix sum_matrix matrix sum_matrix "$MAX_NODES"
  done

  print_associative_array sum_matrix

  local -n result_matrix=$3
  utils_init_square_matrix result_matrix "$MAX_NODES"
  for key in "${!sum_matrix[@]}"; do
    if [ "${sum_matrix[$key]}" -ge "$alpha" ]; then
      result_matrix[$key]=1
    fi
  done
  # print_associative_array result_matrix
  local -A depth
  pkg_retrieve_graph result_matrix depth

  declare -a mark
  index=0
  utils_init_array_by_length mark "$MAX_NODES"
  cycle=true
  
  for i in "${!depth[@]}"; do
    if [ "${depth[$i]}" -eq 0 ]; then
      dfs "$i"
    fi
  done
  echo $cycle
}

dfs() {
    u=$1
    if [[ -n ${mark[$u]} || $cycle ]]; then
      cycle=true
      return
    fi
    mark[$u]=1
    res_pref[$index]=$u
    ((index++))
    for ((v = 0; v < depth[$u]; v++)); do
      depth[$v]=$((${depth[$v]} - ${result_matrix[$pos]}))
      if [ "${depth[$v]}" -eq 0 ]; then
        dfs $v
      fi
    done
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

  if [[ -n $inform_port ]]; then
    echo "node=$node_id calculate done with result: ${result[*]}" | nc localhost "$inform_port"
  fi
}

pkg_check_condition() {
  local -n sum_mtrx=$1
  for key in "${!sum_matrix[@]}"; do
    if [ "${sum_mtrx[$key]}" -gt 0 ]; then
      echo true
    fi
  done
  echo false
}