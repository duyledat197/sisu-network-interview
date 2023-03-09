#!/usr/local/bin/bash

handle_new_block() {
  request=("$@")
  snow_ball

}

handle_retrieve_neighbour_nodes() {
  local -n request=$1
  retrieve_neighbour_nodes
}

handle_connect_node() {
  request=("$@")
  snow_ball
}
