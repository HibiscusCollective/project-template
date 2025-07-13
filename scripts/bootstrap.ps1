# Project Bootstrap Script for Windows
# Auto-detects project type and sets up development environment

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptDir

function Log-Info { param($msg) Write-Host "ℹ️  $msg" -ForegroundColor Blue }
function Log-Success { param($msg) Write-Host "✅ $msg" -ForegroundColor Green }
function Log-Warning { param($msg) Write-Host "⚠️  $msg" -ForegroundColor Yellow }
function Log-Error { param($msg) Write-Host "❌ $msg" -ForegroundColor Red }
function Log-Step { param($msg) Write-Host "🔧 $msg" -ForegroundColor Cyan }

Write-Host "🚀 Auto-detecting and bootstrapping development environment..." -ForegroundColor Green

# Check if we're on Windows
if ($PSVersionTable.Platform -and $PSVersionTable.Platform -ne "Win32NT") {
    Log-Error "This script is for Windows only."
    Write-Host "For Linux/macOS, use bootstrap.sh"
    exit 1
}

# Core setup function
function Setup-Core {
    Log-Step "Setting up core tools (mise + GitHub token)..."
    $MiseScript = "$ScriptDir\bootstrap\mise.ps1"
    
    if (Test-Path $MiseScript) {
        & $MiseScript
    } else {
        Log-Warning "Core mise setup script not found, using built-in setup"
        
        # Install mise if not present
        if (-not (Get-Command mise -ErrorAction SilentlyContinue)) {
            Log-Step "Installing mise..."
            irm https://mise.run | iex
            $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")
        }
        
        # Install tools first (including gh CLI)
        Set-Location $ProjectRoot
        mise install
        
        # Setup GitHub token using gh CLI
        Log-Step "Setting up GitHub token for API rate limits..."
        $LocalTomlPath = "$ProjectRoot\mise.local.toml"
        if (-not (Test-Path $LocalTomlPath)) {
            # Ensure gh is available
            if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
                Log-Error "gh CLI not found. Please ensure it's defined in mise.toml"
                Log-Warning "Skipping GitHub token setup - you may hit API rate limits"
            } else {
                # Check if user is already authenticated
                try {
                    gh auth status *>$null
                    $authenticated = $LASTEXITCODE -eq 0
                } catch {
                    $authenticated = $false
                }
                
                if ($authenticated) {
                    Log-Step "Getting GitHub token from gh CLI..."
                    try {
                        $githubToken = gh auth token 2>$null
                        
                        if ($githubToken) {
                            @"
[env]
GITHUB_TOKEN = "$githubToken"
"@ | Out-File -FilePath $LocalTomlPath -Encoding UTF8
                            Log-Success "GitHub token configured from gh CLI in mise.local.toml"
                        } else {
                            Log-Warning "Failed to get GitHub token from gh CLI, falling back to manual entry"
                            $githubToken = Read-Host "Enter GitHub token manually (no permissions needed, just for API rate limits)" -AsSecureString
                            $plainToken = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($githubToken))
                            
                            if ($plainToken) {
                                @"
[env]
GITHUB_TOKEN = "$plainToken"
"@ | Out-File -FilePath $LocalTomlPath -Encoding UTF8
                                Log-Success "GitHub token configured manually in mise.local.toml"
                            } else {
                                Log-Warning "No GitHub token provided - you may hit API rate limits"
                            }
                        }
                    } catch {
                        Log-Warning "Failed to get GitHub token from gh CLI, falling back to manual entry"
                        $githubToken = Read-Host "Enter GitHub token manually (no permissions needed, just for API rate limits)" -AsSecureString
                        $plainToken = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($githubToken))
                        
                        if ($plainToken) {
                            @"
[env]
GITHUB_TOKEN = "$plainToken"
"@ | Out-File -FilePath $LocalTomlPath -Encoding UTF8
                            Log-Success "GitHub token configured manually in mise.local.toml"
                        } else {
                            Log-Warning "No GitHub token provided - you may hit API rate limits"
                        }
                    }
                } else {
                    Log-Step "GitHub CLI not authenticated. Choose an option:"
                    Write-Host "1. Authenticate with gh CLI (run: gh auth login)"
                    Write-Host "2. Enter token manually"
                    $choice = Read-Host "Enter choice (1/2)"
                    
                    if ($choice -eq "2") {
                        $githubToken = Read-Host "Enter GitHub token (no permissions needed, just for API rate limits)" -AsSecureString
                        $plainToken = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($githubToken))
                        
                        if ($plainToken) {
                            @"
[env]
GITHUB_TOKEN = "$plainToken"
"@ | Out-File -FilePath $LocalTomlPath -Encoding UTF8
                            Log-Success "GitHub token configured manually in mise.local.toml"
                        } else {
                            Log-Warning "No GitHub token provided - you may hit API rate limits"
                        }
                    } else {
                        Log-Warning "Please run 'gh auth login' and re-run this script"
                        Log-Warning "Skipping GitHub token setup - you may hit API rate limits"
                    }
                }
            }
        } else {
            Log-Success "GitHub token already configured in mise.local.toml"
        }
    }
}

# Run all platform-specific bootstrap scripts
function Run-BootstrapScripts {
    Log-Step "Running all bootstrap scripts for this platform..."
    
    $BootstrapDir = "$ScriptDir\bootstrap"
    $ScriptCount = 0
    
    # Check if bootstrap directory exists
    if (-not (Test-Path $BootstrapDir -PathType Container)) {
        Log-Warning "Bootstrap directory not found at $BootstrapDir"
        return
    }
    
    # Run all .ps1 scripts in the bootstrap directory
    $Scripts = Get-ChildItem -Path $BootstrapDir -Filter "*.ps1" -ErrorAction SilentlyContinue
    
    foreach ($Script in $Scripts) {
        $ScriptName = $Script.Name
        Log-Step "Running bootstrap script: $ScriptName"
        
        try {
            & $Script.FullName
            $ScriptCount++
        } catch {
            Log-Error "Failed to execute $ScriptName`: $($_.Exception.Message)"
        }
    }
    
    if ($ScriptCount -eq 0) {
        Log-Info "No .ps1 bootstrap scripts found in $BootstrapDir"
    } else {
        Log-Success "Executed $ScriptCount bootstrap script(s)"
    }
}

# Main execution
function Main {
    Setup-Core
    Run-BootstrapScripts
    
    # Verify installation
    Log-Step "Verifying installation..."
    if (Get-Command mise -ErrorAction SilentlyContinue) { mise --version }
    
    Write-Host ""
    Log-Success "Bootstrap completed successfully!"
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "1. Restart your PowerShell session"
    Write-Host "2. Run project-specific commands (check README.md)"
    Write-Host ""
}

Main