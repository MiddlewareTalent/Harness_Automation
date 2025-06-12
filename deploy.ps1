# PowerShell script to deploy inputs.conf and restart Splunk UF

$ErrorActionPreference = 'Stop'

# Splunk UF install location
$ufLocalPath = "C:\Program Files\SplunkUniversalForwarder"
$inputsConfPath = "$ufLocalPath\etc\system\local\inputs.conf"

# Step 1: Copy inputs.conf to Splunk UF config directory
Copy-Item ".\inputs.conf" -Destination $inputsConfPath -Force

# Step 2: Parse log path from inputs.conf
$inputsConf = Get-Content ".\inputs.conf"
$logLine = $inputsConf | Where-Object { $_ -like '[monitor://*' }

if ($logLine -match '\[monitor://(.*)\]') {
    $logPath = $matches[1]

    # Step 3: Ensure the log file exists
    if (-Not (Test-Path $logPath)) {
        New-Item -ItemType File -Path $logPath -Force | Out-Null
        Add-Content -Path $logPath -Value "Log initialized at $(Get-Date)"
    }
} else {
    Write-Error "No valid monitor stanza found in inputs.conf"
    exit 1
}

# Step 4: Restart Splunk UF
& "$ufLocalPath\bin\splunk.exe" restart
