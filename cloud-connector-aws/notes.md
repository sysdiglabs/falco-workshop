# Sync rules directory to bucket
cc_bucket=$(aws cloudformation list-stack-resources --stack-name CloudConnector --output json | jq '.StackResourceSummaries[] | select(.LogicalResourceId=="CloudConnectorBucket").PhysicalResourceId' | xargs)
echo $cc_bucket
aws s3 sync "./rules/" s3://$cc_bucket/rules --delete

# Restart Cloud Connector so new rule files are processed
task_id=$(aws ecs list-tasks --cluster CloudConnector --output json | jq '.taskArns[0]' | xargs | sed -E 's/.*\/(.+)/\1/') 
echo $task_id 
AWS_PAGER="" aws ecs stop-task --cluster CloudConnector --task $task_id

# Check new log stream name for new Cloud Connector instance
aws logs describe-log-streams --log-group-name cloud-connector --order-by LastEventTime --descending | grep -m1 "ecs/CloudConnector/"
cc_log_stream=CHANGE_TO_NEW_LOG_STREAM

# Read new log stream to check that log files have been processed
aws logs filter-log-events --log-group-name cloud-connector --log-stream-names $cc_log_stream --filter-patter "-http-server -console-notifier“

# Check latest security events
aws logs get-log-events --log-group-name cloud-connector --log-stream-name alerts --no-start-from-head --limit 5
