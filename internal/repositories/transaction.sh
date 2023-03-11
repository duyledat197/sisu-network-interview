#!/usr/local/bin/bash

repo_create_transaction() {
  local tx_id=$1
  sqlite3 $DATA_PATH "INSERT INTO transactions (tx_id) VALUES ('$tx_id');"
}

repo_is_transaction_exists() {
  local tx_id=$1
  echo $(sqlite3 $DATA_PATH "SELECT EXISTS(SELECT 1 FROM transactions WHERE tx_id='$tx_id');")
}
