#!/usr/local/bin/bash

migrate_data() {
  node_id=$NODE_ID
  cat ./internal/migrations/migrations.sql | sqlite3 ./data/$node_id.db
}
