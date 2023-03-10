#!/usr/local/bin/bash

handle_new_block() {
  request=("$@")
  # snow_ball

}

handle_retrieve_neighbour_nodes() {
  local -n req=$1
  local -n res=$2
  local -A neighbour_nodes
  retrieve_neighbour_nodes neighbour_nodes
}

handle_connect_node() {
  request=("$@")
  # snow_ball
}
