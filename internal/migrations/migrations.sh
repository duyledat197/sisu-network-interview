#!/usr/local/bin/bash

mogrations_migrate_data() {
  cat ./internal/migrations/migrations.sql | sqlite3 ./data/$node_id.db
}
