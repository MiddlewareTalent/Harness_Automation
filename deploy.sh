#!/bin/bash

# Hardcoded Splunk HEC values
SPLUNK_URL="https://prd-p-xugh6.splunkcloud.com"
HEC_TOKEN="a6a4f859-d3ee-4331-92ac-02b9bd9ea9b7"

# Specify the log file and sourcetype directly here
LOGFILE="logs/app.log"         # ✅ Change this to your desired log file
SOURCETYPE="IPL"               # ✅ Change this to your desired sourcetype
INDEX="harness_demo"           # ✅ Change this to your desired index

# Debug info
echo "Sending logs to: $SPLUNK_URL"
echo "Using sourcetype: $SOURCETYPE"
echo "Using index: $INDEX"
echo "Log file: $LOGFILE"

# Validate the log file exists
if [[ -f "$LOGFILE" ]]; then
  echo "📤 Sending $LOGFILE to Splunk..."
  while IFS= read -r line; do
    curl --silent --output /dev/null \
      -k "$SPLUNK_URL/services/collector" \
      -H "Authorization: Splunk $HEC_TOKEN" \
      -H "Content-Type: application/json" \
      -d "{\"event\": \"$line\", \"sourcetype\": \"$SOURCETYPE\", \"index\": \"$INDEX\"}" \
      --write-out '{"text":"Success","code":0}\n'
  done < "$LOGFILE"
else
  echo "❌ Log file not found: $LOGFILE"
  exit 1
fi

echo "✅ Deployment finished!"