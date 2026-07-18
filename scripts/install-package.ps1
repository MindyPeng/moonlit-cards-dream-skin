[CmdletBinding()]
param(
  [string]$InstallRoot = (Join-Path $env:LOCALAPPDATA 'MoonlitCardsDreamSkin'),
  [switch]$NoLaunch
)

$ErrorActionPreference = 'Stop'
$sourceRoot = Split-Path -Parent $PSScriptRoot
$sourceWindows = Join-Path $sourceRoot 'windows'
$InstallRoot = [System.IO.Path]::GetFullPath($InstallRoot)
$localAppData = [System.IO.Path]::GetFullPath($env:LOCALAPPDATA).TrimEnd('\') + '\'
if (-not $InstallRoot.StartsWith($localAppData, [System.StringComparison]::OrdinalIgnoreCase)) {
  throw 'InstallRoot must be a child of LOCALAPPDATA.'
}
if (-not (Test-Path -LiteralPath (Join-Path $sourceWindows 'scripts\install-dream-skin.ps1'))) {
  throw 'The release payload is incomplete.'
}

$oldRestore = Join-Path $InstallRoot 'windows\scripts\restore-dream-skin.ps1'
$restore = if (Test-Path -LiteralPath $oldRestore) { $oldRestore } else { Join-Path $sourceWindows 'scripts\restore-dream-skin.ps1' }
& $restore -ForceRestart -NoRelaunch

$installedWindows = Join-Path $InstallRoot 'windows'
if (Test-Path -LiteralPath $installedWindows) {
  Remove-Item -LiteralPath $installedWindows -Recurse -Force
}
New-Item -ItemType Directory -Force -Path (Join-Path $InstallRoot 'scripts') | Out-Null
Copy-Item -LiteralPath $sourceWindows -Destination $InstallRoot -Recurse -Force
Copy-Item -LiteralPath (Join-Path $sourceRoot 'Uninstall.cmd') -Destination (Join-Path $InstallRoot 'Uninstall.cmd') -Force
Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'uninstall-package.ps1') -Destination (Join-Path $InstallRoot 'scripts\uninstall-package.ps1') -Force

$installedScripts = Join-Path $installedWindows 'scripts'
& (Join-Path $installedScripts 'install-dream-skin.ps1')
if (-not $NoLaunch) {
  & (Join-Path $installedScripts 'start-dream-skin.ps1')
}
Write-Host "Moonlit Cards Dream Skin installed at $InstallRoot"
