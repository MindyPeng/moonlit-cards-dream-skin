[CmdletBinding()]
param([string]$OutputDirectory)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$version = (Get-Content -LiteralPath (Join-Path $root 'VERSION') -Raw).Trim()
if ($version -notmatch '^\d+\.\d+\.\d+$') { throw 'VERSION must use semantic versioning.' }
if (-not $OutputDirectory) { $OutputDirectory = Join-Path $root 'outputs' }
$OutputDirectory = [System.IO.Path]::GetFullPath($OutputDirectory)
$packageName = "Moonlit-Cards-Dream-Skin-Windows-v$version"
$staging = Join-Path ([System.IO.Path]::GetTempPath()) "$packageName-$([guid]::NewGuid().ToString('N'))"
$packageRoot = Join-Path $staging $packageName

$files = @(
  '.gitignore', 'Install.cmd', 'Uninstall.cmd', 'LICENSE', 'NOTICE.md', 'README.md', 'README.en.md', 'ARTWORK.md', 'VERSION',
  'scripts\build-windows-release.ps1', 'scripts\install-package.ps1', 'scripts\uninstall-package.ps1',
  'windows\assets\dream-skin.css', 'windows\assets\moonlit-cards-original.png', 'windows\assets\renderer-inject.js', 'windows\assets\theme.json',
  'windows\scripts\common-windows.ps1', 'windows\scripts\config-utf8.ps1', 'windows\scripts\image-metadata.mjs',
  'windows\scripts\injector.mjs', 'windows\scripts\install-dream-skin.ps1', 'windows\scripts\restore-dream-skin.ps1',
  'windows\scripts\start-dream-skin.ps1', 'windows\scripts\theme-windows.ps1', 'windows\scripts\tray-dream-skin.ps1',
  'windows\scripts\verify-dream-skin.ps1', 'windows\tests\image-metadata.test.mjs',
  'windows\tests\injector-bootstrap.test.mjs', 'windows\tests\injector-one-shot.test.mjs',
  'windows\tests\renderer-inject.test.mjs', 'windows\tests\run-tests.ps1'
)

try {
  foreach ($relative in $files) {
    $source = Join-Path $root $relative
    if (-not (Test-Path -LiteralPath $source -PathType Leaf)) { throw "Release file is missing: $relative" }
    $destination = Join-Path $packageRoot $relative
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $destination) | Out-Null
    Copy-Item -LiteralPath $source -Destination $destination -Force
  }

  $badNames = @(Get-ChildItem -LiteralPath $packageRoot -Recurse -File | Where-Object {
    $_.Name -like '*.before-*' -or $_.Name -in @('state.json', 'injector.log', 'injector-error.log', 'verify.log')
  })
  if ($badNames.Count -gt 0) { throw "Runtime or backup files entered the release: $($badNames.FullName -join ', ')" }
  foreach ($file in Get-ChildItem -LiteralPath $packageRoot -Recurse -File | Where-Object Extension -in @('.ps1', '.cmd', '.mjs', '.js', '.css', '.json', '.md', '.txt')) {
    $content = [System.IO.File]::ReadAllText($file.FullName)
    if ($content -match '(?i)C:\\Users\\[^\\\s''"]+') {
      throw "A personal Windows user path was found in $($file.FullName)"
    }
  }

  New-Item -ItemType Directory -Force -Path $OutputDirectory | Out-Null
  $zip = Join-Path $OutputDirectory "$packageName.zip"
  Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
  Compress-Archive -LiteralPath $packageRoot -DestinationPath $zip -CompressionLevel Optimal
  $hash = (Get-FileHash -LiteralPath $zip -Algorithm SHA256).Hash.ToLowerInvariant()
  $hashFile = "$zip.sha256"
  [System.IO.File]::WriteAllText($hashFile, "$hash  $([System.IO.Path]::GetFileName($zip))`r`n", [System.Text.Encoding]::ASCII)
  Write-Host $zip
  Write-Host $hashFile
} finally {
  if (Test-Path -LiteralPath $staging) { Remove-Item -LiteralPath $staging -Recurse -Force }
}
