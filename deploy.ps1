$ErrorActionPreference = 'Stop'

$ufLocalPath = "C:\Program Files\SplunkUniversalForwarder"
$inputsConfPath = "$ufLocalPath\etc\system\local\inputs.conf"

# Step 1: Read and parse inputs.conf
$inputsConf = Get-Content ".\inputs.conf"

# Extract monitor stanza
$monitorLine = $inputsConf | Where-Object { $_ -match '^\[monitor://.+\]$' }
$logPath = ($monitorLine -replace '^\[monitor://', '') -replace '\]$', ''

# Extract index and sourcetype
$index = ($inputsConf | Where-Object { $_ -match '^index\s*=' }) -replace 'index\s*=\s*', ''
$sourcetype = ($inputsConf | Where-Object { $_ -match '^sourcetype\s*=' }) -replace 'sourcetype\s*=\s*', ''

Write-Host "📁 Monitoring Path: $logPath"
Write-Host "📦 Index: $index"
Write-Host "🧾 Sourcetype: $sourcetype"

# Step 2: Copy inputs.conf to UF config
Copy-Item ".\inputs.conf" -Destination $inputsConfPath -Force

# Step 3: Ensure log file exists
If (-Not (Test-Path $logPath)) {
    New-Item -ItemType File -Path $logPath -Force | Out-Null
    Add-Content -Path $logPath -Value "Log initialized at $(Get-Date)"
}

# Step 4: Restart Splunk UF
& "$ufLocalPath\bin\splunk.exe" restart
