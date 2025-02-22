# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "This script needs to be run as Administrator. Please restart with elevated privileges."
    exit
}

function Install-ChocoPackage {
    param (
        [string]$PackageName,
        [string]$DisplayName
    )
    Write-Host "`nInstalling $DisplayName..."
    try {
        choco install $PackageName -y
        Write-Host "$DisplayName installed successfully!" -ForegroundColor Green
    }
    catch {
        Write-Host "Error installing ${DisplayName}: $_" -ForegroundColor Red
    }
}

# Install Chocolatey if not installed
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey..."
    try {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        
        # Refresh environment variables
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
        
        Write-Host "Chocolatey installed successfully!" -ForegroundColor Green
    }
    catch {
        Write-Host "Error installing Chocolatey: $_" -ForegroundColor Red
        exit
    }
}

# Array of packages to install
$packages = @(
    @{Name = "vscode"; DisplayName = "Visual Studio Code"},
    @{Name = "microsoft-windows-terminal"; DisplayName = "Windows Terminal"},
    @{Name = "nodejs"; DisplayName = "Node.js"},
    @{Name = "python"; DisplayName = "Python"},
    @{Name = "git"; DisplayName = "Git"}
)

# Install packages
foreach ($package in $packages) {
    Install-ChocoPackage -PackageName $package.Name -DisplayName $package.DisplayName
}

# Configure Git (only if installation was successful)
if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Host "`nConfiguring Git..."
    
    # Prompt for user information
    $userName = Read-Host "Enter your Git username"
    $userEmail = Read-Host "Enter your Git email"

    # Configure Git global settings
    git config --global user.name $userName
    git config --global user.email $userEmail
    git config --global init.defaultBranch main

    # Verify Git configuration
    Write-Host "`nGit configuration has been updated. Current settings:"
    Write-Host "----------------------------------------"
    git config --global --list | Select-String "user.name|user.email|init.defaultBranch"
}

# Display installed versions
Write-Host "`nInstalled Versions:"
Write-Host "----------------------------------------"
try { Write-Host "VS Code: $((code --version)[0])" } catch { Write-Host "VS Code version check failed" }
try { Write-Host "Node.js: $(node --version)" } catch { Write-Host "Node.js version check failed" }
try { Write-Host "Python: $(python --version)" } catch { Write-Host "Python version check failed" }
try { Write-Host "Git: $(git --version)" } catch { Write-Host "Git version check failed" }

# Refresh environment variables one final time
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

Write-Host "`nSetup completed! Please restart your terminal to ensure all changes take effect." -ForegroundColor Green