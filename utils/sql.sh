#!/usr/local/bin/bash

# set -x

#! tested
join_strings() {
  arr=("$@")
  delimiter=','
  result=$(printf "${delimiter}%s" "${arr[@]}")
  result=${result:${#delimiter}}
  echo $result
}

#! tested
get_values() {
  local -n dta=$1
  local -n pars=$2
  local size=$3
  local -a strs

  for ((i = 0; i < $size; i++)); do
    local -a vals
    for j in ${!pars[@]}; do
      param_name=${pars[$j]}
      val=${dta[$i, $param_name]}
      vals[$j]=$val
    done
    str="($(join_strings ${vals[@]}))"
    strs[$i]=$str
  done

  echo $(join_strings ${strs[@]})
  echo ""
}
