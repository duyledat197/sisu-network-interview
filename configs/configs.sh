#!/usr/local/bin/bash

#? environments
export MAX_NODES=20
export SAMPLE_SIZE=20
export QUORUM_SIZE=14
export DECISION_THRESHOLD=20

#? paths

# DATA_PATH=./data new place in main
export RESULT_PATH=./seed/result.db

#? events
export NEW_BLOCK_EVENT="new_block_event"
export RETRIEVE_DATA_EVENT="retrieve_data_event"
