#!/usr/local/bin/bash

#? environments
export MAX_NODES=50
export SAMPLE_SIZE=10
export QUORUM_SIZE=14
export DECISION_THRESHOLD=20

#? paths

# DATA_PATH=./data new place in main
export RESULT_DB_PATH=./seed/result.db

#? events
export UPDATE_DATA_EVENT="UPDATE_DATA_EVENT"
export REQUEST_DATA_EVENT="REQUEST_DATA_EVENT"
export RESPONSE_DATA_EVENT="RESPONSE_DATA_EVENT"

#? set limit
ulimit -v 4294967296
ulimit -t 10

