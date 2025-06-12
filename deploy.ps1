# PowerShell script to deploy inputs.conf and restart Splunk UF

$ErrorActionPreference = 'Stop'

$ufLocalPath = "C:\Program Files\SplunkUniversalForwarder"
$logPath = "C:\Splunkuf_logs_demo\app.log"
$inputsConfPath = "$ufLocalPath\etc\system\local\inputs.conf"

# Copy inputs.conf to UF config
Copy-Item ".\inputs.conf" -Destination $inputsConfPath -Force

# Ensure log file exists
If (-Not (Test-Path $logPath)) {
    New-Item -ItemType File -Path $logPath -Force | Out-Null
    Add-Content -Path $logPath -Value "Log initialized at $(Get-Date)"
}

# Restart Splunk UF
& "$ufLocalPath\bin\splunk.exe" restart
