#!/bin/bash

# Check latest security events
aws logs get-log-events --log-group-name cloud-connector --log-stream-name alerts --no-start-from-head --limit 5
