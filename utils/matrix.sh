#!/usr/local/bin/bash

utils_get_matrix_from_nodes() {
  local -n nds=$1
  local -n result=$2
  utils_init_square_matrix result $MAX_NODES

# print_associative_array nds
  for ((i = 0; i < sample_size; i++)); do
    for ((j = 0; j < MAX_NODES; j++)); do
      if [[ -z ${nds[$i,$j]} ]]; then
        break
      fi
      local -a arr
      for ((k = 0; k < j; k++)); do
        first=${nds[$i,$j]}
        second=${arr[$k]}
        result[$first,$second]=$((${result[$first,$second]} + 1))
        # echo "i=$i j=$j k=$k first=$first second=$second"
      done
      # set -x
      arr[$j]=${nds[$i,$j]}
      # set +x
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
  local -n square_matrix=$1
  local size=$2
  for ((i = 0; i < $size; i++)); do
    for ((j = 0; j < $size; j++)); do
      first=$(($i + $first_port))
      second=$(($j + $first_port))
      square_matrix[$first,$second]=0
    done
  done
}

#! tested
utils_add_square_matrix() {
  local -n matrixA=$1
  local -n matrixB=$2
  local size=$3
  for ((m_i = 0; m_i < $size; m_i++)); do
    for ((j = 0; j < $size; j++)); do
      first=$(($m_i + $first_port))
      second=$(($j + $first_port))
      matrixA[$first,$second]=$((${matrixA[$first,$second]} + ${matrixB[$first,$second]}))
    done
  done
}

debug_matrix() {
  local -n debug_matrix=$1
  for ((i = first_port; i < first_port + sample_size; i++)); do
    for ((j = first_port; j < first_port + sample_size; j++)); do
      if [[ ${debug_matrix[$i,$j]} -gt "0" ]]; then
        echo "i=$i, j=$j val=${debug_matrix[$i,$j]}"

      fi
    done
  done
}
