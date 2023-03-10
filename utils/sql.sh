#!/usr/local/bin/bash

# set -x

#! tested
utils_join_strings() {
  local -n arr=$1
  local delimiter=$2
  if [[ -z $delimiter ]];then 
    delimeter=","
  fi
  result=$(printf "${delimiter}%s" "${arr[@]}")
  result=${result:${#delimiter}}
  echo $result
}

#! tested
utils_get_values() {
  local -n dta=$1
  local -n pars=$2
  local size=$3
  local -a strs

  for ((i = 0; i < $size; i++)); do
    local -a vals
    for j in "${!pars[@]}"; do
      param_name=${pars[$j]}
      val=${dta[$i, $param_name]}
      vals[$j]=$val
    done
    str="($(utils_join_strings vals))"
    strs[$i]=$str
  done

  echo $(utils_join_strings strs)
  echo ""
}
