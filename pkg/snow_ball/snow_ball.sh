#!/usr/local/bin/bash

pkg_snow_ball() {
  # set -x
  #! load configs
  sample_size="$SAMPLE_SIZE"
  preference=($(seq 1 "$MAX_NODES"))
  consecutiveSuccesses=0
  while true; do
    echo "consecutiveSuccesses=$consecutiveSuccesses"
    #* create  a selection
    selection_id=$(uuid)
    local -A neighbour_nodes
    repo_retrieve_neighbour_nodes neighbour_nodes
    chosen_nodes=($(utils_generate_random_some_numbers_from_array neighbour_nodes "$sample_size"))
    for chosen_node in "${chosen_nodes[@]}"; do
      local -A request
      request[target_port]=$chosen_node
      request[selection_id]=$selection_id
      request[from_port]="$node_id"
      client_request_get_neighbour_nodes request
      sleep 0.5
    done
    total=$(repo_count_selection_by_id "$selection_id")

    local -A preferences
    local -a current_preference
    local -A greater_matrix
    cycle=false
    repo_retrieve_selection_neighbour_nodes "$selection_id" preferences
    pkg_retrieve_preference preferences current_preference greater_matrix cycle

    if [[ ! $(pkg_check_condition greater_matrix) || $cycle ]]; then
      consecutiveSuccesses=0
      continue
    fi
    # set -x
    if [[ $(utils_compare_array preference current_preference) = true ]]; then
      ((consecutiveSuccesses++))
      # set +x
    else
      preference=("${current_preference[*]}")
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
  sample_size="$SAMPLE_SIZE"

  local -A sum_matrix
  local -n prefs=$1
  local -n res_pref=$2
  local -n result_matrix=$3
  local -n c=$4

  utils_get_matrix_from_nodes prefs sum_matrix
  utils_init_square_matrix result_matrix "$MAX_NODES"
  echo "prefs"
  for ((i=0; i<= sample_size; i++));do
    echo -n "{"
    for ((j=0; j<= MAX_NODES; j++));do
      echo -n "${prefs[$i,$j]}, "
  done
  echo  "}"
  done

  for key in "${!sum_matrix[@]}"; do
    if [ "${sum_matrix[$key]}" -ge "$alpha" ]; then
      result_matrix[$key]=1
    fi
    echo "result_matrix"
  for ((i=first_port; i<=first_port + MAX_NODES ; i++));do
    echo -n "{"
    for ((j=first_port; j<= first_port + MAX_NODES; j++));do
      echo -n "${result_matrix[$i,$j]}, "
  done
  echo  "}"
  done
  done
  local -a depth
  local -a mark
  utils_init_array_by_length mark "$MAX_NODES"
  local -a stack
  stackIndex=0

  for ((i = first_port; i <= first_port + MAX_NODES; i++)); do
    if [[ "${depth[$i]}" -eq "0" ]]; then
      ((stackIndex++))
        stack[$stackIndex]=$i
    fi
  done
 
   index=0
  while [[ $stackIndex -gt 0 ]];do
    u=${stack[$stackIndex]}
    ((stackIndex--))
    res_pref[$index]=$u
    ((index++))
   for ((v = first_port; v <= first_port + MAX_NODES; v++)); do
    if [[ ${result_matrix[$v,$u]} -eq "1" ]]; then
      ((depth[$v]--))
      if [[ ${depth[$v]} -eq "0" ]]; then
        ((stackIndex++))
        stack[$stackIndex]=$v
      fi
    fi
   done
  done
  echo "res_pref=${res_pref[*]}"
}

#! tested
pkg_retrieve_graph() {
  local -n matrix=$1
  local -n d=$2
  local size=$MAX_NODES

  utils_init_array_by_length d "$size"
  for ((i = first_port; i <= first_port + size; i++)); do
    for ((j = first_port; j <= first_port + size; j++)); do
      if [[ "${matrix[$i,$j]}" -ge 1 ]]; then
        ((d[$i]++))
      fi
    done
  done
  for ((i = first_port; i <= first_port + size; i++)); do
    echo "i=$i depth=${depth[$i]}"
  done
}

pkg_decide() {
  local -n decied_preference=$1
  local -A data
  index=0
  echo ${decied_preference[*]}
  for i in "${!result[@]}"; do
    val=${decied_preference[$i]}
    pos=$(($i + 1))
    data[$index,node_id]=$node_id
    data[$index,neighbour_id]=$val
    data[$index,position]=$pos
    ((index++))
  done

  repo_upsert_neighbour_nodes data $index

  if [[ -n $inform_port ]]; then
    echo "node=$node_id calculate done with result: ${decied_preference[*]}" | nc localhost "$inform_port"
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
