#!/usr/local/bin/bash

#! tested
create_random_permutation_array() {
  n=$1
  arr=($(seq 1 $n))
  result=($(shuf -e "${arr[@]}"))
  echo ${result[@]}
}

#! tested
generate_random_numbers_from_correct_array() {
  array=("$@")
  size=$(($RANDOM % ${#array[@]} + 1))
  subset=$(shuf -e "${array[@]}" | head -n $size)
  echo ${subset[@]}
}

#! tested
input() {
  local str
  read -p "input array: " str
  read -a $1 <<<"$str"
}

#! tested
get_min_free_port() {
  local port=9000
  while :; do
    if ! netstat -atwn | grep -q "$port"; then
      break
    fi
    ((port++))
  done
  echo $port
}

#! tested
generate_random_numbers() {
  local -n array=$1
  local -n res=$2
  local size=$3
  generated_array=($(shuf -e ${array[@]} | head -n $size))
  for ((i = 0; i < ${#generated_array[@]}; i++)); do
    res[$i]=${generated_array[$i]}
  done
}