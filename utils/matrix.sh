#!/usr/local/bin/bash

utils_get_matrix_from_nodes() {
  local -n nds=$1
  local -n result=$2
  utils_init_square_matrix result $MAX_NODES

  for ((i = 0; i < ${#nds[@]}; i++)); do
    for ((j = 0; j < $i; j++)); do
      first=$((${nds[$i]} + "$first_port"))
      second=$((${nds[$j]} + "$first_port"))
      result[$first,$second]=$((result[$first,$second] + 1))
    done
  done
}

#! tested
utils_compare_matrix() {
  local -n matrixA=$1
  local -n matrixB=$2
  if [ "${matrixA[*]}" == "${matrixB[*]}" ]; then
    echo true
  else
    echo false
  fi
}

#! tested
utils_init_square_matrix() {
  local -n i_matrix=$1
  local size=$2
  for ((i = 0; i < $size; i++)); do
    for ((j = 0; j < $size; j++)); do
      i_matrix[$(($i + $first_port)),$(($j + $first_port))]=0
    done
  done
}

#! tested
utils_add_square_matrix() {
  local -n matrixA=$1
  local -n matrixB=$2
  local -n res=$3
  local size=$4
  echo "utils_add_square_matrix $i"
  for ((m_i = 0; m_i < $size; m_i++)); do
    for ((j = 0; j < $size; j++)); do
      first=$(($m_i + $first_port))
      second=$(($j + $first_port))
      res[$first,$second]=$((${matrixA[$first,$second]} + ${matrixB[$first,$second]}))
    done
  done
}
