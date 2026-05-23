Add-Type -AssemblyName System.Drawing

function New-Bitmap($width, $height) {
  $bitmap = New-Object System.Drawing.Bitmap($width, $height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
  $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
  $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
  $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  return @{ Bitmap = $bitmap; Graphics = $graphics }
}

function New-RoundedRectPath($x, $y, $width, $height, $radius) {
  $path = New-Object System.Drawing.Drawing2D.GraphicsPath
  $diameter = $radius * 2
  $path.AddArc($x, $y, $diameter, $diameter, 180, 90)
  $path.AddArc($x + $width - $diameter, $y, $diameter, $diameter, 270, 90)
  $path.AddArc($x + $width - $diameter, $y + $height - $diameter, $diameter, $diameter, 0, 90)
  $path.AddArc($x, $y + $height - $diameter, $diameter, $diameter, 90, 90)
  $path.CloseFigure()
  return $path
}

function Save-Png($bitmap, $path) {
  $bitmap.Save((Join-Path $PSScriptRoot "..\$path"), [System.Drawing.Imaging.ImageFormat]::Png)
}

function Draw-Magnifier($g, $cx, $cy, $r, $color, $stroke) {
  $circlePen = [System.Drawing.Pen]::new($color, [single]$stroke)
  $circlePen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
  $circlePen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
  $g.DrawEllipse($circlePen, $cx - $r, $cy - $r, $r * 2, $r * 2)
  $circlePen.Dispose()

  $handlePen = [System.Drawing.Pen]::new($color, [single]$stroke)
  $handlePen.StartCap = [System.Drawing.Drawing2D.LineCap]::Flat
  $handlePen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
  $g.DrawLine($handlePen, $cx + ($r * 0.83), $cy + ($r * 0.83), $cx + ($r * 1.45), $cy + ($r * 1.45))
  $handlePen.Dispose()
}

function Draw-BlockSlash($g, $x1, $y1, $x2, $y2, $stroke) {
  $shadow = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(210, 8, 12, 20), [single]($stroke + 2))
  $shadow.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
  $shadow.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
  $g.DrawLine($shadow, $x1 + 1, $y1 + 1, $x2 + 1, $y2 + 1)
  $shadow.Dispose()

  $white = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(245, 255, 255, 255), [single]([Math]::Max(1, $stroke * 0.45)))
  $white.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
  $white.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
  $g.DrawLine($white, $x1, $y1, $x2, $y2)
  $white.Dispose()

  $red = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 238, 74, 74), [single]$stroke)
  $red.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
  $red.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
  $g.DrawLine($red, $x1, $y1, $x2, $y2)
  $red.Dispose()
}

function Draw-SearchBar($g, $x, $y, $w, $h, $theme, $showPlaceholder) {
  if ($theme -eq "light") {
    $fill = [System.Drawing.Color]::FromArgb(255, 248, 248, 250)
    $border = [System.Drawing.Color]::FromArgb(255, 201, 205, 214)
    $text = [System.Drawing.Color]::FromArgb(255, 86, 89, 102)
    $icon = [System.Drawing.Color]::FromArgb(255, 55, 58, 70)
  } elseif ($theme -eq "black") {
    $fill = [System.Drawing.Color]::FromArgb(255, 5, 6, 9)
    $border = [System.Drawing.Color]::FromArgb(255, 50, 54, 66)
    $text = [System.Drawing.Color]::FromArgb(255, 156, 163, 178)
    $icon = [System.Drawing.Color]::FromArgb(255, 190, 196, 207)
  } else {
    $fill = [System.Drawing.Color]::FromArgb(255, 43, 45, 54)
    $border = [System.Drawing.Color]::FromArgb(255, 78, 82, 96)
    $text = [System.Drawing.Color]::FromArgb(255, 218, 221, 230)
    $icon = [System.Drawing.Color]::FromArgb(255, 220, 224, 232)
  }

  $path = New-RoundedRectPath $x $y $w $h ([Math]::Round($h / 4))
  $brush = New-Object System.Drawing.SolidBrush($fill)
  $pen = [System.Drawing.Pen]::new($border, [single]([Math]::Max(1, $h / 42)))
  $g.FillPath($brush, $path)
  $g.DrawPath($pen, $path)
  $brush.Dispose()
  $pen.Dispose()
  $path.Dispose()

  if ($showPlaceholder) {
    $pillPath = New-RoundedRectPath ($x + ($h * 0.30)) ($y + ($h * 0.38)) ($w * 0.46) ($h * 0.14) ($h * 0.07)
    $placeholderBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(150, $text.R, $text.G, $text.B))
    $g.FillPath($placeholderBrush, $pillPath)
    $placeholderBrush.Dispose()
    $pillPath.Dispose()
  }

  Draw-Magnifier $g ($x + $w - ($h * 0.42)) ($y + ($h * 0.46)) ($h * 0.16) $icon ([Math]::Max(2, $h * 0.045))
}

function Draw-Icon($size, $path) {
  $ctx = New-Bitmap $size $size
  $g = $ctx.Graphics
  $g.Clear([System.Drawing.Color]::Transparent)

  if ($size -le 64) {
    $stroke = [Math]::Max(2, $size / 8)
    if ($size -ge 48) {
      $bg = New-RoundedRectPath ($size * 0.06) ($size * 0.06) ($size * 0.88) ($size * 0.88) ($size * 0.20)
      $bgBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 24, 27, 36))
      $g.FillPath($bgBrush, $bg)
      $bgBrush.Dispose()
      $bg.Dispose()
    }
    Draw-Magnifier $g ($size * 0.47) ($size * 0.43) ($size * 0.24) ([System.Drawing.Color]::FromArgb(255, 235, 239, 247)) $stroke
    Draw-BlockSlash $g ($size * 0.20) ($size * 0.80) ($size * 0.80) ($size * 0.20) ([Math]::Max(2, $size / 6))
  } else {
    $bg = New-RoundedRectPath ($size * 0.125) ($size * 0.125) ($size * 0.75) ($size * 0.75) ($size * 0.14)
    $bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
      (New-Object System.Drawing.RectangleF(0, 0, $size, $size)),
      [System.Drawing.Color]::FromArgb(255, 35, 37, 46),
      [System.Drawing.Color]::FromArgb(255, 14, 16, 23),
      45
    )
    $g.FillPath($bgBrush, $bg)
    $outline = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 88, 96, 115), [single]([Math]::Max(1, $size * 0.015)))
    $g.DrawPath($outline, $bg)
    $bgBrush.Dispose()
    $outline.Dispose()
    $bg.Dispose()

    Draw-SearchBar $g ($size * 0.22) ($size * 0.39) ($size * 0.56) ($size * 0.22) "dark" $true
    Draw-BlockSlash $g ($size * 0.32) ($size * 0.70) ($size * 0.72) ($size * 0.30) ([Math]::Max(5, $size * 0.075))
  }

  Save-Png $ctx.Bitmap $path
  $g.Dispose()
  $ctx.Bitmap.Dispose()
}

function Draw-PromoSmall() {
  $ctx = New-Bitmap 440 280
  $g = $ctx.Graphics
  $g.Clear([System.Drawing.Color]::FromArgb(255, 20, 22, 30))

  $font = New-Object System.Drawing.Font("Segoe UI", 27, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
  $subtitleFont = New-Object System.Drawing.Font("Segoe UI", 15, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
  $white = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 245, 247, 252))
  $muted = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 188, 195, 208))
  $g.DrawString("Discord Search Blocker", $font, $white, 36, 34)
  $g.DrawString("Hide Discord search", $subtitleFont, $muted, 38, 68)
  $font.Dispose()
  $subtitleFont.Dispose()
  $white.Dispose()
  $muted.Dispose()

  Draw-SearchBar $g 50 122 340 70 "dark" $true
  Draw-BlockSlash $g 122 222 318 90 20
  Save-Png $ctx.Bitmap "assets/store/cws-small-promo-440x280.png"
  $g.Dispose()
  $ctx.Bitmap.Dispose()
}

function Draw-PromoLarge() {
  $ctx = New-Bitmap 1400 560
  $g = $ctx.Graphics
  $g.Clear([System.Drawing.Color]::FromArgb(255, 18, 20, 27))

  $left = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.RectangleF(0, 0, 1400, 560)),
    [System.Drawing.Color]::FromArgb(255, 43, 45, 54),
    [System.Drawing.Color]::FromArgb(255, 5, 6, 9),
    0
  )
  $g.FillRectangle($left, 0, 0, 1400, 560)
  $left.Dispose()

  $glow = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(28, 238, 74, 74))
  $g.FillEllipse($glow, 440, 40, 520, 520)
  $glow.Dispose()

  $font = New-Object System.Drawing.Font("Segoe UI", 72, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
  $subtitleFont = New-Object System.Drawing.Font("Segoe UI", 34, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
  $white = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 245, 247, 252))
  $muted = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 188, 195, 208))
  $g.DrawString("Discord Search Blocker", $font, $white, 260, 82)
  $g.DrawString("Hide Discord search", $subtitleFont, $muted, 266, 170)
  $font.Dispose()
  $subtitleFont.Dispose()
  $white.Dispose()
  $muted.Dispose()

  Draw-SearchBar $g 260 250 880 130 "dark" $true
  Draw-BlockSlash $g 420 453 980 177 38

  Save-Png $ctx.Bitmap "assets/store/cws-marquee-promo-1400x560.png"
  $g.Dispose()
  $ctx.Bitmap.Dispose()
}

Draw-Icon 16 "assets/icons/icon-16.png"
Draw-Icon 32 "assets/icons/icon-32.png"
Draw-Icon 48 "assets/icons/icon-48.png"
Draw-Icon 64 "assets/icons/icon-64.png"
Draw-Icon 128 "assets/icons/icon-128.png"
Draw-PromoSmall
Draw-PromoLarge
