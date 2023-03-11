#!/usr/local/bin/bash

#? environments
export MAX_NODES=20
export SAMPLE_SIZE=20
export QUORUM_SIZE=14
export DECISION_THRESHOLD=20

#? paths

# DATA_PATH=./data new place in main
export RESULT_DB_PATH=./seed/result.db

#? events
export UPDATE_DATA_EVENT="update_data_event"
export REQUEST_DATA_EVENT="REQUEST_DATA_EVENT"
