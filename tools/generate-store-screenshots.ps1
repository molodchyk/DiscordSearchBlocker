Add-Type -AssemblyName System.Drawing

$ErrorActionPreference = "Stop"

$root = Resolve-Path (Join-Path $PSScriptRoot "..")
$outDir = Join-Path $root "assets/store/screenshots"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$sources = @(
  @{
    Path = "C:\Users\molod\Pictures\Screenshots\Screenshot 2026-05-23 140126.png"
    Out = "02-search-visible-light.png"
    Label = "Before: search visible"
    Highlight = "visible"
    Theme = "light"
  },
  @{
    Path = "C:\Users\molod\Pictures\Screenshots\Screenshot 2026-05-23 140058.png"
    Out = "03-search-hidden-light.png"
    Label = "After: search hidden"
    Highlight = "hidden"
    Theme = "light"
  },
  @{
    Path = "C:\Users\molod\Pictures\Screenshots\Screenshot 2026-05-23 140139.png"
    Out = "04-search-visible-dark.png"
    Label = "Dark: search visible"
    Highlight = "visible"
    Theme = "dark"
  },
  @{
    Path = "C:\Users\molod\Pictures\Screenshots\Screenshot 2026-05-23 140148.png"
    Out = "05-search-hidden-dark.png"
    Label = "Dark: search hidden"
    Highlight = "hidden"
    Theme = "dark"
  }
)

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

function Draw-Label($g, $text, $theme) {
  $font = [System.Drawing.Font]::new("Segoe UI", 24, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
  if ($theme -eq "light") {
    $fill = [System.Drawing.Color]::FromArgb(232, 255, 255, 255)
    $border = [System.Drawing.Color]::FromArgb(255, 210, 214, 222)
    $textColor = [System.Drawing.Color]::FromArgb(255, 35, 38, 48)
  } else {
    $fill = [System.Drawing.Color]::FromArgb(232, 30, 33, 43)
    $border = [System.Drawing.Color]::FromArgb(255, 88, 96, 115)
    $textColor = [System.Drawing.Color]::FromArgb(255, 245, 247, 252)
  }

  $rect = New-RoundedRectPath 28 92 430 46 10
  $brush = [System.Drawing.SolidBrush]::new($fill)
  $pen = [System.Drawing.Pen]::new($border, 2)
  $g.FillPath($brush, $rect)
  $g.DrawPath($pen, $rect)
  $brush.Dispose()
  $pen.Dispose()
  $rect.Dispose()

  $textBrush = [System.Drawing.SolidBrush]::new($textColor)
  $g.DrawString($text, $font, $textBrush, 44, 101)
  $textBrush.Dispose()
  $font.Dispose()
}

function Draw-SearchHighlight($g, $kind) {
  if ($kind -eq "visible") {
    $penColor = [System.Drawing.Color]::FromArgb(255, 238, 74, 74)
  } else {
    $penColor = [System.Drawing.Color]::FromArgb(255, 48, 196, 118)
  }

  $pen = [System.Drawing.Pen]::new($penColor, 5)
  $pen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
  $pen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round

  if ($kind -eq "visible") {
    $path = New-RoundedRectPath 986 52 278 42 10
  } else {
    $path = New-RoundedRectPath 1016 52 252 42 10
  }
  $g.DrawPath($pen, $path)
  $path.Dispose()
  $pen.Dispose()
}

function Draw-PrivacyOverlay($g, $theme) {
  if ($theme -eq "light") {
    $fill = [System.Drawing.Color]::FromArgb(255, 247, 248, 251)
    $line = [System.Drawing.Color]::FromArgb(255, 214, 219, 229)
    $text = [System.Drawing.Color]::FromArgb(255, 75, 80, 96)
  } else {
    $fill = [System.Drawing.Color]::FromArgb(255, 22, 24, 32)
    $line = [System.Drawing.Color]::FromArgb(255, 62, 68, 84)
    $text = [System.Drawing.Color]::FromArgb(255, 178, 185, 202)
  }

  $rect = New-RoundedRectPath 306 110 910 670 12
  $brush = [System.Drawing.SolidBrush]::new($fill)
  $g.FillPath($brush, $rect)
  $brush.Dispose()
  $rect.Dispose()

  $pen = [System.Drawing.Pen]::new($line, 12)
  $pen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
  $pen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
  for ($i = 0; $i -lt 11; $i++) {
    $y = 148 + ($i * 56)
    $g.DrawLine($pen, 330, $y, 1000, $y)
    $g.DrawLine($pen, 330, $y + 22, 1140, $y + 22)
  }
  $pen.Dispose()

  $font = [System.Drawing.Font]::new("Segoe UI", 20, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
  $textBrush = [System.Drawing.SolidBrush]::new($text)
  $g.DrawString("Message content obscured for privacy", $font, $textBrush, 336, 742)
  $font.Dispose()
  $textBrush.Dispose()
}

foreach ($source in $sources) {
  $input = [System.Drawing.Image]::FromFile($source.Path)
  $output = [System.Drawing.Bitmap]::new(1280, 800, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $g = [System.Drawing.Graphics]::FromImage($output)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
  $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

  $srcRect = [System.Drawing.Rectangle]::new(50, 82, 1229, 768)
  $dstRect = [System.Drawing.Rectangle]::new(0, 0, 1280, 800)
  $g.DrawImage($input, $dstRect, $srcRect, [System.Drawing.GraphicsUnit]::Pixel)

  Draw-PrivacyOverlay $g $source.Theme
  Draw-Label $g $source.Label $source.Theme
  Draw-SearchHighlight $g $source.Highlight

  $output.Save((Join-Path $outDir $source.Out), [System.Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose()
  $output.Dispose()
  $input.Dispose()
}

function Draw-ComparisonScreenshot() {
  $before = [System.Drawing.Image]::FromFile("C:\Users\molod\Pictures\Screenshots\Screenshot 2026-05-23 140126.png")
  $after = [System.Drawing.Image]::FromFile("C:\Users\molod\Pictures\Screenshots\Screenshot 2026-05-23 140058.png")
  $output = [System.Drawing.Bitmap]::new(1280, 800, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $g = [System.Drawing.Graphics]::FromImage($output)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
  $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

  $bg = [System.Drawing.Drawing2D.LinearGradientBrush]::new(
    [System.Drawing.RectangleF]::new(0, 0, 1280, 800),
    [System.Drawing.Color]::FromArgb(255, 26, 29, 38),
    [System.Drawing.Color]::FromArgb(255, 10, 12, 18),
    0
  )
  $g.FillRectangle($bg, 0, 0, 1280, 800)
  $bg.Dispose()

  $titleFont = [System.Drawing.Font]::new("Segoe UI", 54, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
  $labelFont = [System.Drawing.Font]::new("Segoe UI", 30, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
  $subtitleFont = [System.Drawing.Font]::new("Segoe UI", 28, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
  $white = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 245, 247, 252))
  $muted = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 188, 195, 208))

  $g.DrawString("Discord Search Blocker", $titleFont, $white, 76, 58)
  $g.DrawString("Hide the search field in Discord's web app", $subtitleFont, $muted, 80, 126)

  $beforeCard = New-RoundedRectPath 78 210 1124 210 20
  $afterCard = New-RoundedRectPath 78 488 1124 210 20
  $cardFill = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 238, 241, 246))
  $cardBorder = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 82, 90, 110), 2)
  $g.FillPath($cardFill, $beforeCard)
  $g.FillPath($cardFill, $afterCard)
  $g.DrawPath($cardBorder, $beforeCard)
  $g.DrawPath($cardBorder, $afterCard)

  $srcRect = [System.Drawing.Rectangle]::new(383, 120, 884, 70)
  $g.DrawImage($before, [System.Drawing.Rectangle]::new(104, 280, 1072, 86), $srcRect, [System.Drawing.GraphicsUnit]::Pixel)
  $g.DrawImage($after, [System.Drawing.Rectangle]::new(104, 558, 1072, 86), $srcRect, [System.Drawing.GraphicsUnit]::Pixel)

  $red = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 238, 74, 74))
  $green = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 48, 196, 118))
  $g.DrawString("Before", $labelFont, $red, 104, 222)
  $g.DrawString("After", $labelFont, $green, 104, 500)

  $highlightRed = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 238, 74, 74), 5)
  $highlightGreen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 48, 196, 118), 5)
  $g.DrawPath($highlightRed, (New-RoundedRectPath 846 292 324 50 10))
  $g.DrawPath($highlightGreen, (New-RoundedRectPath 930 570 240 50 10))

  $titleFont.Dispose()
  $labelFont.Dispose()
  $subtitleFont.Dispose()
  $white.Dispose()
  $muted.Dispose()
  $red.Dispose()
  $green.Dispose()
  $highlightRed.Dispose()
  $highlightGreen.Dispose()
  $cardFill.Dispose()
  $cardBorder.Dispose()
  $beforeCard.Dispose()
  $afterCard.Dispose()
  $before.Dispose()
  $after.Dispose()

  $output.Save((Join-Path $outDir "01-before-after-comparison.png"), [System.Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose()
  $output.Dispose()
}

Draw-ComparisonScreenshot

Write-Output $outDir
