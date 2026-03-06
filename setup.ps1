# MWM One-Line Installer
# Usage: iwr https://raw.githubusercontent.com/Michaelmuze82/mwm/master/setup.ps1 | iex

Write-Host ""
Write-Host "  Installing MWM Framework..." -ForegroundColor Red
Write-Host ""

$installDir = "$env:USERPROFILE\mwm-framework"

# Clone or update
if (Test-Path "$installDir\.git") {
    Write-Host "  [*] Updating existing install..." -ForegroundColor Cyan
    git -C $installDir pull --quiet 2>$null
} else {
    if (Test-Path $installDir) { Remove-Item $installDir -Recurse -Force }
    Write-Host "  [*] Downloading MWM..." -ForegroundColor Cyan
    git clone --quiet https://github.com/Michaelmuze82/mwm.git $installDir 2>$null
    if ($LASTEXITCODE -ne 0) {
        # Fallback: download as zip if git isn't available
        Write-Host "  [*] Git not found, downloading zip..." -ForegroundColor Yellow
        $zip = "$env:TEMP\mwm.zip"
        Invoke-WebRequest -Uri "https://github.com/Michaelmuze82/mwm/archive/refs/heads/master.zip" -OutFile $zip
        Expand-Archive -Path $zip -DestinationPath "$env:TEMP\mwm-extract" -Force
        Move-Item "$env:TEMP\mwm-extract\mwm-framework-master" $installDir -Force
        Remove-Item $zip -Force
        Remove-Item "$env:TEMP\mwm-extract" -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# Find Git Bash
$gitBash = $null
if (Test-Path "C:\Program Files\Git\bin\bash.exe") { $gitBash = "C:\Program Files\Git\bin\bash.exe" }
elseif (Test-Path "C:\Program Files (x86)\Git\bin\bash.exe") { $gitBash = "C:\Program Files (x86)\Git\bin\bash.exe" }

if (-not $gitBash) {
    Write-Host "  [!] Git Bash not found. Install Git for Windows first:" -ForegroundColor Red
    Write-Host "      https://git-scm.com/download/win" -ForegroundColor White
    exit 1
}

# Create bin folder and launcher
$binDir = "$env:USERPROFILE\bin"
if (-not (Test-Path $binDir)) { New-Item -ItemType Directory -Path $binDir | Out-Null }

# Create mwm.bat launcher
@"
@echo off
"$gitBash" "$installDir\mwm.sh" %*
"@ | Set-Content "$binDir\mwm.bat" -Encoding ASCII

# Add to PATH if needed
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -notlike "*$binDir*") {
    [Environment]::SetEnvironmentVariable("Path", "$userPath;$binDir", "User")
    $env:Path = "$env:Path;$binDir"
    Write-Host "  [+] Added to PATH" -ForegroundColor Green
}

# Install opencv (optional)
$python = Get-Command python -ErrorAction SilentlyContinue
if ($python) {
    Write-Host "  [*] Installing webcam support..." -ForegroundColor Cyan
    python -m pip install opencv-python --quiet 2>$null
}

Write-Host ""
Write-Host "  =====================================" -ForegroundColor Red
Write-Host "  MWM Framework installed!" -ForegroundColor Green
Write-Host ""
Write-Host "  Open a NEW terminal and type: mwm" -ForegroundColor White
Write-Host "  =====================================" -ForegroundColor Red
Write-Host ""
