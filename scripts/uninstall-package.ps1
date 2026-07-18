[CmdletBinding()]
param([string]$InstallRoot = (Join-Path $env:LOCALAPPDATA 'MoonlitCardsDreamSkin'))

$ErrorActionPreference = 'Stop'
$InstallRoot = [System.IO.Path]::GetFullPath($InstallRoot)
$localAppData = [System.IO.Path]::GetFullPath($env:LOCALAPPDATA).TrimEnd('\') + '\'
if (-not $InstallRoot.StartsWith($localAppData, [System.StringComparison]::OrdinalIgnoreCase)) {
  throw 'InstallRoot must be a child of LOCALAPPDATA.'
}
$restore = Join-Path $InstallRoot 'windows\scripts\restore-dream-skin.ps1'
if (-not (Test-Path -LiteralPath $restore)) { throw 'Moonlit Cards Dream Skin is not installed.' }

$restoreArguments = @('-Uninstall', '-ForceRestart', '-NoRelaunch')
if (Test-Path -LiteralPath (Join-Path $InstallRoot 'config.before-dream-skin.toml')) {
  $restoreArguments += '-RestoreBaseTheme'
}
& $restore @restoreArguments

$cleanup = "Start-Sleep -Seconds 2; Remove-Item -LiteralPath '$($InstallRoot.Replace("'", "''"))' -Recurse -Force"
$encoded = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($cleanup))
Start-Process -FilePath powershell.exe -ArgumentList "-NoProfile -WindowStyle Hidden -EncodedCommand $encoded" -WindowStyle Hidden | Out-Null
Write-Host 'Moonlit Cards Dream Skin was removed and the standard Codex appearance was restored.'
