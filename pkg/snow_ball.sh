#!/usr/local/bin/bash

snow_ball() {
  #! load configs
  sample_size=$SAMPLE_SIZE
  node_id=$NODE_ID

  local -A preference
  init_square_matrix preference $MAX_NODES

  neighbour_nodes=($(get_neighbour_nodes))
  consecutiveSuccesses=0
  while; do
    chosen_nodes=($(generate_random_numbers $neighbour_nodes $sample_size))
    pref=($(retrieve_preference))
    if ${#pref[@]} == 0; then
      consecutiveSuccesses=0
      continue
    fi
    if $(compare_matrix preference pref); then
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

retrieve_preference() {
  sample_size=$SAMPLE_SIZE
  alpha=$QUORUM_SIZE
  beta=$DECISION_THRESHOLD

  local -A sum_matrix
  local -n chosen_nodes=$1

  init_square_matrix sum_matrix $MAX_NODES
  for i in ${!chosen_nodes[@]}; do
    local -A nodes
    local -A matrix
    local -A preference
    local -A request=(
      ["target_port"]=${chosen_node[$i, "port"]}
    )
    local -A response

    request_get_neighbour_nodes request response
    get_relation_matrix ${nodes[@]}
    matrix_addition sum_matrix matrix
  done

  local -A result_matrix=($(init_square_matrix $MAX_NODES))
  for i in ${!sum_matrix[@]}; do
    if ${sum_matrix[$i]} >= alpha; then
      sum_matrix[$i]=1
    fi
  done

  depth=($(retrieve_depth ${result_matrix[@]}))
  declare -a preference
  index=0
  declare -a mark
  dfs() {
    u=$1
    if [[ ! -z ${mark[$u]} ]]; then
      return
    fi
    mark[$u]=1
    preference[index]=u
    index++
    for ((v = 0; v < $MAX_NODES; v++)); do
      pos=$(get_position $v $u)
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

decide() {
  upsert_neighbour_nodes ${preference[@]}
}
