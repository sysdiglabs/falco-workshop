#!/bin/bash

# Check new log stream name for new Cloud Connector instance
cc_log_stream=$(aws logs describe-log-streams --log-group-name cloud-connector --order-by LastEventTime --descending | grep -m1 "ecs/CloudConnector/" | sed 's/"\(.*\)".*"\(.*\)",/\2/' | xargs)
echo $cc_log_stream

# Read new log stream to check that log files have been processed
aws logs filter-log-events --log-group-name cloud-connector --log-stream-names $cc_log_stream --filter-patter "-http-server -console-notifier"

