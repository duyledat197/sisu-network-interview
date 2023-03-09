#!/usr/local/bin/bash

new_array_by_length() {
  n=$1
  declare -a arr
  for ((i = 0; i < n; i++)); do
    arr[$i]=0
  done
  echo ${arr[@]}
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

# declare -A my_array
# my_array["name"]="John"
# my_array["age"]=30
# my_array["city"]="New"
# str1=$(associative_array_to_string my_array)
# echo -e $str1

# declare -A result
# string_to_associative_array "$str1" result

# echo ${result[@]}
