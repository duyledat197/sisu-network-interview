#!/usr/local/bin/bash

source ./utils/sql.sh


utils_init_array_by_length() {
  local -n array=$1
  local size=$2
  for ((i = first_port; i < first_port + size; i++)); do
    array[$i]=0
  done
}

#! tested
utils_create_random_permutation_array() {
  array=($(seq $1 $(($1 + $2))))
  shuf_array=($(shuf -e "${array[@]}"))
  echo "${shuf_array[@]}"
}

#! tested
utils_generate_random_some_numbers_from_array() {
  local -n array=$1
  if [[ ! -z $2 ]]; then
    size=$2
  else
    half=$((${#array[@]}/2))
    size=$(($RANDOM %$half + $half))
  fi
  
  local -a subset
  index=0
  shuffled=$(shuf -e "${array[@]}" -n $size | sort)
  while IFS='' read -r num;do
    subset[$index]=$num
    ((index++))
  done <<< $shuffled

  echo "${subset[@]}"
}
#! tested
utils_array_to_associative_array() {
  local -n array=$1
  local -n associative_array=$2

  for i in "${!array[@]}"; do
    associative_array[$i]=${array[$i]}
  done
}

#! tested
utils_generate_random_numbers() {
  local size=$(($RANDOM % $MAX_NODES + 1))
  arr=($(seq $first_port $(($first_port + $size))))
  echo $(shuf -e "${arr[@]}" | head -n $size)
}

#! tested
utils_associative_array_to_string() {
  local -a strings
  local -n array=$1
  index=0
  for key in "${!array[@]}"; do
    k=$(echo "$key" | tr -d " ")
    strings[$index]="[$k]=${array[$key]}"
    ((index++))
  done

  echo $(utils_join_strings strings "|")
}

#! tested
utils_string_to_associative_array() {
  local str=$2
  local -n arr=$1
  IFS='|' read -ra elements <<<"$str"
  for element in "${elements[@]}"; do
    IFS='=' read -ra pair <<<"$element"
    key=$(echo ${pair[0]} | tr -d '[]')
    val=${pair[1]}
    arr["$key"]="$val"
  done
}

print_associative_array() {
  local -n array=$1
  for key in "${!array[@]}"; do
    echo "[$key]:${array[$key]}"
  done
}

#! tested
utils_compare_array() {
  # set -x
  local -n matrixA=$1
  local -n matrixB=$2
  if [ "${matrixA[*]}" == "${matrixB[*]}" ]; then
    echo true
  else
    echo false
  fi
  # set +x
}

