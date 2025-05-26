#!/bin/bash

# Read sourcetype and index from inputs.conf
SOURCETYPE=$(grep 'sourcetype' inputs.conf | awk -F= '{print $2}' | xargs)
INDEX=$(grep 'index' inputs.conf | awk -F= '{print $2}' | xargs)

SPLUNK_HEC_URL="$SPLUNK_URL"
SPLUNK_TOKEN="$SPLUNK_TOKEN"

echo "Sending logs to: $SPLUNK_HEC_URL"
echo "Using sourcetype: $SOURCETYPE"
echo "Using index: $INDEX"

while IFS= read -r line; do
  curl -s -k "$SPLUNK_HEC_URL/services/collector" \
    -H "Authorization: Splunk $SPLUNK_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"event\": \"$line\", \"sourcetype\": \"$SOURCETYPE\", \"index\": \"$INDEX\"}"
done < log.txt

echo "Deployment finished!!"