#!/usr/local/bin/bash

migrate_data() {
  cat ./internal/migrations/migrations.sql | sqlite3 ./data/$node_id.db
}
