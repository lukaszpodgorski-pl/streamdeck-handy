$logRoot = "$env:APPDATA\Elgato\StreamDeck\logs"
Write-Host "=== Handy plugin logs ==="
Get-ChildItem $logRoot -Filter '*handy*' -ErrorAction SilentlyContinue | Select-Object FullName, Length, LastWriteTime | Format-Table -AutoSize

Write-Host "`n=== Recent main log entries mentioning handy ==="
Get-Content "$logRoot\StreamDeck.log" -Tail 300 | Select-String -Pattern 'handy|com\.lukasz' -SimpleMatch | Select-Object -Last 30

Write-Host "`n=== Last 30 lines of main log ==="
Get-Content "$logRoot\StreamDeck.log" -Tail 30
