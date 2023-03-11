#!/usr/local/bin/bash

declare -a selection_params=("selection_id" "neighbour_id" "data")
repo_create_selection() {
  local -n dt=$1
  values=$(utils_get_values dt )
  sqlite3 $DATA_PATH "INSERT INTO selections (selection_id,neighbour_id, data) VALUES $values;"
}

repo_retrieve_selection_neighbour_nodes() {
  local selection_id=$1
  local -n result=$2
  q=$(sqlite3 $DATA_PATH "SELECT data FROM selections WHERE selection_id='$selection_id';")
   while IFS='' read -r data; do
    result[$index]=$data
    ((index++))
  done <<<$q
}
