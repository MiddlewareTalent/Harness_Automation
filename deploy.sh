# === PowerShell script ===

# Define paths
$ufLocalPath = "C:\Program Files\SplunkUniversalForwarder"
$logPath = "C:\Splunkuf_logs_demo\app.log"
$inputsConfPath = "$ufLocalPath\etc\system\local\inputs.conf"

# Copy updated inputs.conf
Write-Host "📁 Copying inputs.conf to Splunk UF config..."
Copy-Item ".\inputs.conf" -Destination $inputsConfPath -Force

# Ensure log file exists
If (-Not (Test-Path $logPath)) {
    Write-Host "📝 Creating log file at $logPath"
    New-Item -ItemType File -Path $logPath -Force | Out-Null
    Add-Content -Path $logPath -Value "Log file initialized at $(Get-Date)"
} else {
    Write-Host "✅ Log file already exists at $logPath"
}

# Restart Splunk UF to apply changes
Write-Host "🔁 Restarting Splunk Universal Forwarder..."
& "$ufLocalPath\bin\splunk.exe" restart