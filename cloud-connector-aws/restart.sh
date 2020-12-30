#!/bin/bash

# Restart Cloud Connector so new rule files are processed
task_id=$(aws ecs list-tasks --cluster CloudConnector --output json | jq '.taskArns[0]' | xargs | sed -E 's/.*\/(.+)/\1/') 
echo $task_id
AWS_PAGER="" aws ecs stop-task --cluster CloudConnector --task $task_id

