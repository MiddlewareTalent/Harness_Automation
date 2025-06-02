#!/bin/bash
# Hardcoded Splunk HEC values
SPLUNK_URL="https://e4d3-136-232-205-158.ngrok-free.app"
HEC_TOKEN="4f68e260-3555-46c1-84b3-bfecb678d31e"

# Specify the log file and source ltype directly here
LOGFILE="logs/errors.log"         # ✅ Change this to your desired log file
SOURCETYPE="error_logs"           # ✅ Change this to your desired source type
INDEX="harness_demo"     # ✅ Change this to your desired index

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