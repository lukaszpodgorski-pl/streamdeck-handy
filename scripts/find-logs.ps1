$paths = @(
    "$env:APPDATA\Elgato",
    "$env:LOCALAPPDATA\Elgato",
    "$env:APPDATA\Elgato\StreamDeck\logs",
    "$env:LOCALAPPDATA\Elgato\StreamDeck\logs"
)
foreach ($p in $paths) {
    Write-Host "Checking: $p -> Exists: $(Test-Path $p)"
}

$logRoot = "$env:APPDATA\Elgato\StreamDeck\logs"
if (Test-Path $logRoot) {
    Get-ChildItem $logRoot -Recurse -Filter '*.log' | Sort-Object LastWriteTime -Descending | Select-Object -First 10 FullName, Length, LastWriteTime | Format-Table -AutoSize
}
$logRoot2 = "$env:LOCALAPPDATA\Elgato\StreamDeck\logs"
if (Test-Path $logRoot2) {
    Get-ChildItem $logRoot2 -Recurse -Filter '*.log' | Sort-Object LastWriteTime -Descending | Select-Object -First 10 FullName, Length, LastWriteTime | Format-Table -AutoSize
}
