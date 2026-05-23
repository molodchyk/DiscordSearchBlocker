param(
  [string]$OutputDirectory = "dist"
)

$ErrorActionPreference = "Stop"

$root = Resolve-Path (Join-Path $PSScriptRoot "..")
$manifestPath = Join-Path $root "manifest.json"
$manifest = Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json
$version = $manifest.version

$stage = Join-Path $env:TEMP "discord-search-blocker-$version-package"
$outputDir = Join-Path $root $OutputDirectory
$zip = Join-Path $outputDir "discord-search-blocker-$version.zip"

if (Test-Path -LiteralPath $stage) {
  Remove-Item -LiteralPath $stage -Recurse -Force
}

New-Item -ItemType Directory -Force -Path $stage | Out-Null
New-Item -ItemType Directory -Force -Path $outputDir | Out-Null

Copy-Item -LiteralPath (Join-Path $root "manifest.json") -Destination $stage
Copy-Item -LiteralPath (Join-Path $root "LICENSE.txt") -Destination $stage
Copy-Item -LiteralPath (Join-Path $root "_locales") -Destination $stage -Recurse

New-Item -ItemType Directory -Force -Path (Join-Path $stage "src") | Out-Null
Copy-Item -LiteralPath (Join-Path $root "src/content.js") -Destination (Join-Path $stage "src/content.js")

New-Item -ItemType Directory -Force -Path (Join-Path $stage "assets/icons") | Out-Null
Copy-Item -Path (Join-Path $root "assets/icons/*.png") -Destination (Join-Path $stage "assets/icons")

if (Test-Path -LiteralPath $zip) {
  Remove-Item -LiteralPath $zip -Force
}

Compress-Archive -Path (Join-Path $stage "*") -DestinationPath $zip -Force
Remove-Item -LiteralPath $stage -Recurse -Force

Write-Output $zip
