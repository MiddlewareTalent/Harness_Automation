# PowerShell script to deploy inputs.conf and restart Splunk UF

$ufLocalPath = "C:\Program Files\SplunkUniversalForwarder"
$logPath = "C:\Splunkuf_logs_demo\app.log"
$inputsConfPath = "$ufLocalPath\etc\system\local\inputs.conf"
Write-Host "📁 Copying inputs.conf..."
Copy-Item ".\inputs.conf" -Destination $inputsConfPath -Force

If (-Not (Test-Path $logPath)) {
    Write-Host "📝 Creating $logPath..."
    New-Item -ItemType File -Path $logPath -Force | Out-Null
    Add-Content -Path $logPath -Value "Log file initialized at $(Get-Date)"
} else {
    Write-Host "✅ Log file already exists"
}

Write-Host "🔁 Restarting Splunk UF..."
& "$ufLocalPath\bin\splunk.exe" restart