Add-Type -AssemblyName System.Drawing

$base = Join-Path $PSScriptRoot "..\pl.lukaszpodgorski.handy.sdPlugin\imgs"

function New-Icon {
    param(
        [string]$Path,
        [int]$Size,
        [string]$Label,
        [System.Drawing.Color]$BgColor
    )

    $dir = Split-Path $Path -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }

    $bmp = New-Object System.Drawing.Bitmap($Size, $Size)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias
    $g.Clear([System.Drawing.Color]::Transparent)

    # Background rounded rect
    $brush = New-Object System.Drawing.SolidBrush($BgColor)
    $g.FillRectangle($brush, 0, 0, $Size, $Size)

    # Text
    if ($Label) {
        $fontSize = [Math]::Max(6, [int]($Size / 4))
        $font = New-Object System.Drawing.Font("Segoe UI", $fontSize, [System.Drawing.FontStyle]::Bold)
        $textBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
        $sf = New-Object System.Drawing.StringFormat
        $sf.Alignment = [System.Drawing.StringAlignment]::Center
        $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
        $rect = New-Object System.Drawing.RectangleF(0, 0, $Size, $Size)
        $g.DrawString($Label, $font, $textBrush, $rect, $sf)
        $font.Dispose()
        $textBrush.Dispose()
    }

    $g.Dispose()
    $bmp.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    $brush.Dispose()
    Write-Host "Created: $Path ($Size x $Size)"
}

$blue = [System.Drawing.Color]::FromArgb(255, 30, 110, 200)
$red  = [System.Drawing.Color]::FromArgb(255, 200, 50, 50)
$gray = [System.Drawing.Color]::FromArgb(255, 80, 80, 90)
$purple = [System.Drawing.Color]::FromArgb(255, 120, 60, 180)

# Plugin icon (20x20, 40x40)
New-Icon -Path "$base\plugin-icon.png"    -Size 20 -Label "H" -BgColor $blue
New-Icon -Path "$base\plugin-icon@2x.png" -Size 40 -Label "H" -BgColor $blue

# Category icon (20x20, 40x40)
New-Icon -Path "$base\category-icon.png"    -Size 28 -Label "H" -BgColor $blue
New-Icon -Path "$base\category-icon@2x.png" -Size 56 -Label "H" -BgColor $blue

# Toggle action icons (20x20, 40x40) + state images (72x72, 144x144)
New-Icon -Path "$base\actions\toggle\icon.png"         -Size 20 -Label "T"   -BgColor $blue
New-Icon -Path "$base\actions\toggle\icon@2x.png"      -Size 40 -Label "T"   -BgColor $blue
New-Icon -Path "$base\actions\toggle\idle.png"         -Size 72 -Label "MIC" -BgColor $gray
New-Icon -Path "$base\actions\toggle\idle@2x.png"      -Size 144 -Label "MIC" -BgColor $gray
New-Icon -Path "$base\actions\toggle\recording.png"    -Size 72 -Label "REC" -BgColor $red
New-Icon -Path "$base\actions\toggle\recording@2x.png" -Size 144 -Label "REC" -BgColor $red

# Cancel
New-Icon -Path "$base\actions\cancel\icon.png"    -Size 20 -Label "X" -BgColor $red
New-Icon -Path "$base\actions\cancel\icon@2x.png" -Size 40 -Label "X" -BgColor $red

# Post-process
New-Icon -Path "$base\actions\post-process\icon.png"    -Size 20 -Label "P" -BgColor $purple
New-Icon -Path "$base\actions\post-process\icon@2x.png" -Size 40 -Label "P" -BgColor $purple

Write-Host "Done."
