# Path to Splunk UF and local log
$ufLocalPath = "C:\Program Files\SplunkUniversalForwarder"
$logPath = "C:\Splunkuf_logs_demo\app.log"
$inputsConfPath = "$ufLocalPath\etc\system\local\inputs.conf"

# Copy inputs.conf to Splunk UF
Copy-Item ".\inputs.conf" -Destination $inputsConfPath -Force

# Ensure log file exists
# shellcheck disable=SC1073
# shellcheck disable=SC1065
# shellcheck disable=SC1081
# shellcheck disable=SC1072
# shellcheck disable=SC1064
If (-Not (Test-Path $logPath)) {
    New-Item -ItemType File -Path $logPath -Force | Out-Null
    Add-Content -Path $logPath -Value "Log file initialized at $(Get-Date)"
}

# Restart Splunk UF
& "$ufLocalPath\bin\splunk.exe" restart