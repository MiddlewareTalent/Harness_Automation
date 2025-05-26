#!/bin/bash

SPLUNK_HEC_URL="$SPLUNK_URL"
SPLUNK_TOKEN="$SPLUNK_TOKEN"
INDEX="main"
SOURCETYPE="harness-demo"

echo "Sending logs to: $SPLUNK_HEC_URL"

for log in logs/*.log; do
  while IFS= read -r line; do
    curl -s -k "$SPLUNK_HEC_URL/services/collector" \
      -H "Authorization: Splunk $SPLUNK_TOKEN" \
      -H "Content-Type: application/json" \
      -d "{\"event\": \"$line\", \"sourcetype\": \"$SOURCETYPE\", \"index\": \"$INDEX\"}"
  done < "$log"
done

echo "Deployment finished!"
