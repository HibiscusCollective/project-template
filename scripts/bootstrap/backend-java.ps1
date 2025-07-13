# Java Backend Bootstrap Script for Windows
# Sets up Java development environment and validates existing Java projects

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = (Get-Item $ScriptDir).Parent.Parent.FullName

function Log-Info { param($msg) Write-Host "ℹ️  $msg" -ForegroundColor Blue }
function Log-Success { param($msg) Write-Host "✅ $msg" -ForegroundColor Green }
function Log-Warning { param($msg) Write-Host "⚠️  $msg" -ForegroundColor Yellow }
function Log-Error { param($msg) Write-Host "❌ $msg" -ForegroundColor Red }
function Log-Step { param($msg) Write-Host "🔧 $msg" -ForegroundColor Cyan }

Write-Host "☕ Setting up Java development environment..." -ForegroundColor Green

# Verify Java and Gradle are available
Log-Step "Verifying Java and Gradle installation..."

if (-not (Get-Command java -ErrorAction SilentlyContinue)) {
    Log-Error "Java not found. Ensure 'mise install' has been run."
    exit 1
}

if (-not (Get-Command gradle -ErrorAction SilentlyContinue)) {
    Log-Error "Gradle not found. Ensure 'mise install' has been run."
    exit 1
}

$JavaVersion = (java -version 2>&1 | Select-String "version" | ForEach-Object { $_.ToString().Split('"')[1] })
$GradleVersion = (gradle --version | Select-String "Gradle" | ForEach-Object { $_.ToString().Split(' ')[1] })

Log-Success "Java $JavaVersion detected"
Log-Success "Gradle $GradleVersion detected"

# Check for Java backend projects and validate them
Log-Step "Checking Java backend projects..."

$JavaProjectsFound = 0

Get-ChildItem -Path "$ProjectRoot\backend" -Directory -ErrorAction SilentlyContinue | ForEach-Object {
    $ProjectDir = $_.FullName
    $BuildGradlePath = "$ProjectDir\build.gradle"
    
    if (Test-Path $BuildGradlePath) {
        $ProjectName = $_.Name
        Log-Info "Found Java project: $ProjectName"
        
        # Test if the project builds
        Push-Location $ProjectDir
        try {
            $BuildResult = gradle build --quiet 2>&1
            if ($LASTEXITCODE -eq 0) {
                Log-Success "✓ $ProjectName builds successfully"
            } else {
                Log-Warning "⚠ $ProjectName has build issues"
            }
        } catch {
            Log-Warning "⚠ $ProjectName has build issues"
        } finally {
            Pop-Location
        }
        
        $JavaProjectsFound++
    }
}

if ($JavaProjectsFound -eq 0) {
    Log-Warning "No Java projects found in backend\ directory"
    Log-Info "Java development environment is ready for new projects"
} else {
    Log-Success "Found and validated $JavaProjectsFound Java project(s)"
}

Write-Host ""
Log-Success "Java development environment setup complete!"
Write-Host ""
Log-Info "Available commands for Java projects:"
Write-Host "  gradle build    # Build the project"
Write-Host "  gradle run      # Run the application"
Write-Host "  gradle test     # Run tests"
Write-Host "  gradle clean    # Clean build artifacts"