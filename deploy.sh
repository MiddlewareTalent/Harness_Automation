#!/bin/bash

SPLUNK_URL="https://prd-p-xugh6.splunkcloud.com"
HEC_TOKEN="a6a4f859-d3ee-4331-92ac-02b9bd9ea9b7"

# Define fixed values known to work
SOURCETYPE="RCB"
INDEX="harness_demo"

echo "Sending logs to: $SPLUNK_URL"
echo "Using sourcetype: $SOURCETYPE"
echo "Using index: $INDEX"

for logfile in logs/*.log; do
  echo "📤 Sending $logfile to Splunk..."
  while IFS= read -r line; do
    curl --silent --output /dev/null \
      -k "$SPLUNK_URL/services/collector" \
      -H "Authorization: Splunk $HEC_TOKEN" \
      -H "Content-Type: application/json" \
      -d "{\"event\": \"$line\", \"sourcetype\": \"$SOURCETYPE\", \"index\": \"$INDEX\"}" \
      --write-out '{"text":"Success","code":0}\n'
  done < "$logfile"
done

echo "✅ Deployment finished!"
