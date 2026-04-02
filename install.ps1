# shellsurf installer for Windows
# Usage: irm https://shellsurf.com/install.ps1 | iex
$ErrorActionPreference = "Stop"

$repo = "samuelahmed/shellsurf-releases"
$version = "v0.2.0"
$target = "x86_64-pc-windows-msvc"
$archive = "shellsurf-$version-$target.zip"
$url = "https://github.com/$repo/releases/download/$version/$archive"

$installDir = if ($env:SHELLSURF_INSTALL_DIR) { $env:SHELLSURF_INSTALL_DIR } else { "$env:LOCALAPPDATA\shellsurf" }

Write-Host "Installing shellsurf $version for $target..."

# Create install directory
New-Item -ItemType Directory -Force -Path $installDir | Out-Null

# Download
$tmp = Join-Path ([System.IO.Path]::GetTempPath()) $archive
Invoke-WebRequest -Uri $url -OutFile $tmp

# Extract
Expand-Archive -Path $tmp -DestinationPath $installDir -Force
Remove-Item $tmp -Force

Write-Host ""
Write-Host "shellsurf installed to $installDir\shellsurf.exe"

# Add to PATH if not already there
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -notlike "*$installDir*") {
    [Environment]::SetEnvironmentVariable("Path", "$userPath;$installDir", "User")
    $env:Path = "$env:Path;$installDir"
    Write-Host ""
    Write-Host "Added $installDir to your PATH (restart your terminal to use 'shellsurf' globally)."
}

Write-Host ""
Write-Host "Run 'shellsurf' to get started."
