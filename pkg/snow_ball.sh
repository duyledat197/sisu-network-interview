#!/usr/local/bin/bash

pkg_snow_ball() {
  #! load configs
  sample_size=$SAMPLE_SIZE
  node_id=$NODE_ID

  local -A neighbour_nodes
  repo_retrieve_neighbour_nodes neighbour_nodes

  local -A preference
  utils_init_square_matrix preference $MAX_NODES

  consecutiveSuccesses=0
  while; do
    chosen_nodes=($(utils_generate_random_some_numbers_from_array ${neighbour_nodes[@]} $sample_size))
    pref=($(pkg_retrieve_preference chosen_nodes))
    if ${#pref[@]} == 0; then
      consecutiveSuccesses=0
      continue
    fi
    if $(utils_compare_matrix preference pref); then
      ((consecutiveSuccesses++))
    else
      consecutiveSuccesses=1
    fi
    if $consecutiveSuccesses >= $beta; then
      decide
      break
    fi
  done
}

pkg_retrieve_preference() {
  sample_size=$SAMPLE_SIZE
  alpha=$QUORUM_SIZE
  beta=$DECISION_THRESHOLD

  local -A sum_matrix
  local -n chosen_nodes=$1

  utils_init_square_matrix sum_matrix $MAX_NODES
  for i in ${!chosen_nodes[@]}; do
    local -A nodes
    local -A matrix
    local -A preference
    local -A request=(
      ["target_port"]=${chosen_node[$i, "port"]}
    )
    local -A response

    client_request_get_neighbour_nodes request response
    get_relation_matrix ${nodes[@]}
    matrix_addition sum_matrix matrix
  done

  local -A result_matrix
  utils_init_square_matrix result_matrix $MAX_NODES
  for i in ${!sum_matrix[@]}; do
    if ${sum_matrix[$i]} >= alpha; then
      result_matrix[$i]=1
    fi
  done

  local -A depth
  local -A vertex
  pkg_retrieve_graph sum_matrix vertex depth $MAX_NODES

  declare -a preference
  index=0
  declare -a mark
  dfs() {
    u=$1
    if [[ ! -z ${mark[$u]} ]]; then
      return
    fi
    mark[$u]=1
    preference[index]=$u
    ((index++))
    for ((v = 0; v < depth[$u]; v++)); do
      vertex
      depth[$v]=$((depth[$v] - result_matrix[$pos]))
      if ${depth[$v]} == 0; then
        dfs $v
      fi
    done
  }
  for i in ${!depth[@]}; do
    if ${depth[$i]} == 0; then
      dfs $i
    fi
  done
  return ${preference[@]}
}

#! tested
pkg_retrieve_graph() {
  local -n matrix=$1
  local -n vertx=$2
  local -n dept=$3
  local size=$4

  utils_init_associative_array_by_length dept $size
  for ((i = 0; i < $size; i++)); do
    for ((j = 0; j < $size; j++)); do
      if ${matrix[$i, $j]} == 1; then
        vertx[${depth[$i]}]=$j
        depth[$i]=$((depth[$i] + 1))
      fi
    done
  done
}

pkg_decide() {
  repo_upsert_neighbour_nodes ${preference[@]}
}
