#!/usr/local/bin/bash

declare -a selection_params=("selection_id" "neighbour_id" "data")
repo_create_selection() {
  local -n dt=$2
  selection_id=$1
  neighbour_id=${dt[neighbour_id]}
  data=${dt[data]}
  sqlite3 $DATA_PATH "INSERT INTO selections (selection_id,neighbour_id, data) VALUES ('$selection_id', '$neighbour_id', '{$data}');"
}

repo_retrieve_selection_neighbour_nodes() {
  local selection_id=$1
  local -n result=$2
  q=$(sqlite3 $DATA_PATH "SELECT data FROM selections WHERE selection_id='$selection_id';")
  row=0
  while read -r rows; do
    slice_rows=()
    IFS=',' read -ra slice_rows <<< "$(echo "$rows" | tr -d '{}')"
    for col in "${!slice_rows[@]}"; do 
    val=${slice_rows[$col]}
     result[$row,$col]="$val"
    done
    ((row++))
  done <<<$q
}
