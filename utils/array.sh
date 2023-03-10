#!/usr/local/bin/bash

new_associative_array_by_length() {
  n=$1
  local -a arr
  for ((i = 0; i < $n; i++)); do
    arr[$i]=0
  done
}

init_associative_array_by_length() {
  local -n array=$1
  local size=$2

  for ((i = 0; i < $size; i++)); do
    array[$i]=0
  done
}

#! tested
associative_array_to_string() {
  local str=""
  local -n array=$1
  for key in "${!array[@]}"; do
    str+="[\"$key\"]=\"${array[$key]}\" "
  done
  echo "( $str )"
}

#! tested
string_to_associative_array() {
  local str=$1
  local -n array=$2
  array=$str
}

#! tested
create_random_permutation_array() {
  result=$(shuf -e $(seq 1 $1))
  echo ${result[@]}
}

#! tested
generate_random_some_numbers_from_array() {
  array=("$@")
  size=$(($RANDOM % ${#array[@]} + 1))
  local -a subset
  index=0
  chosen_indexes=$(shuf -i 0-$((${#array[@]} - 1)) -n $size | sort)
  for i in ${chosen_indexes[@]}; do
    subset[$index]=${array[$i]}
    ((index++))
  done

  echo ${subset[@]}
}
#! tested
array_to_associative_array() {
  local -n array=$1
  local -n associative_array=$2

  for i in ${!array[@]}; do
    associative_array[$i]=${array[$i]}
  done
}

#! tested
generate_random_numbers() {
  local size=$(($RANDOM % $1 + 1))
  arr=$(seq 1 $size)

  echo $(shuf -e ${arr[@]} | head -n $size)
}
