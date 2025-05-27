#!/bin/bash

# Hardcoded Splunk HEC values
SPLUNK_URL="https://prd-p-xugh6.splunkcloud.com"
HEC_TOKEN="a6a4f859-d3ee-4331-92ac-02b9bd9ea9b7"

# Set fixed sourcetype and index
SOURCETYPE="RCBB"
INDEX="harness_demo"

# Echo for debugging
echo "Sending logs to: $SPLUNK_URL"

# Create a sample log file (if needed)
echo "Test log from Harness at $(date)" > log.txt

# Send log.txt first — this mimics the working example
while IFS= read -r line; do
  curl --silent --output /dev/null \
    -k "$SPLUNK_URL/services/collector" \
    -H "Authorization: Splunk $HEC_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"event\": \"$line\", \"sourcetype\": \"$SOURCETYPE\", \"index\": \"$INDEX\"}" \
    --write-out '{"text":"Success","code":0}\n'
done < log.txt

# Now send all .log files in logs/ folder
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
