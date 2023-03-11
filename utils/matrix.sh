#!/usr/local/bin/bash

utils_get_matrix_from_nodes() {
  local -n nodes=$1
  local -n result=$2
  utils_init_square_matrix result $MAX_NODES

  for ((i = 0; i < ${#nodes[@]}; i++)); do
    for ((j = 0; j < $i; j++)); do
      first=${nodes[$i]}
      second=${nodes[$j]}
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
  local -n matrix=$1
  local size=$2
  for ((i = 0; i < $size; i++)); do
    for ((j = 0; j < $size; j++)); do
      matrix[$i,$j]=0
    done
  done
}

#! tested
utils_add_square_matrix() {
  local -n matrixA=$1
  local -n matrixB=$2
  local -n res=$3
  local size=$4
  for ((i = 0; i < $size; i++)); do
    for ((j = 0; j < $size; j++)); do
      res[$i,$j]=$((matrixA[$i,$j] + matrixB[$i,$j]))
    done
  done
}
