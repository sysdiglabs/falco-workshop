#!/bin/bash

# Sync rules directory to bucket
cc_bucket=$(aws cloudformation list-stack-resources --stack-name CloudConnector --output json | jq '.StackResourceSummaries[] | select(.LogicalResourceId=="CloudConnectorBucket").PhysicalResourceId' | xargs)
echo $cc_bucket
aws s3 sync "./rules/" s3://$cc_bucket/rules --delete

