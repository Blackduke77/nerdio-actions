<#
.SYNOPSIS
Installs Microsoft Teams 2.0 client machine-wide and configures auto-start, open-in-background, and installs Teams Outlook Add-in.

.DESCRIPTION
Downloads and installs the latest Microsoft Teams client using the Evergreen PowerShell module.
Auto-configures Teams behavior for new users and cleans up all temp files and modules.
Designed for use as a Nerdio Scripted Action during image preparation.

.ExecutionContext
System

.NOTES
- Requires internet access during install.
- Tested on Windows 10/11 Enterprise multi-session and Pro.
#>

try {
    Write-Output "Starting Microsoft Teams 2.0 installation using Evergreen..."

    # --- Ensure Evergreen is Installed ---
    if (-not (Get-Module -ListAvailable -Name Evergreen)) {
        Write-Output "Evergreen module not found. Installing Evergreen module..."
        Install-PackageProvider -Name NuGet -Force -Scope AllUsers -ErrorAction Stop
        Set-PSRepository -Name PSGallery -InstallationPolicy Trusted -ErrorAction Stop
        Install-Module -Name Evergreen -Force -Scope AllUsers -ErrorAction Stop
    }
    else {
        Write-Output "Evergreen module is already installed."
    }
    Import-Module Evergreen -Force

    # --- Create Download Folder ---
    $downloadPath = "$env:TEMP\TeamsInstall"
    if (-not (Test-Path $downloadPath)) {
        New-Item -Path $downloadPath -ItemType Directory -Force | Out-Null
    }

    # --- Fetch Latest Teams MSIX Installer ---
    Write-Output "Fetching latest Microsoft Teams 2.0 MSIX installer via Evergreen..."
    $teamsApp = Get-EvergreenApp -Name "MicrosoftTeams" | Where-Object { $_.Release -eq "Enterprise" -and $_.Architecture -eq "x64" } | Select-Object -First 1
    if ($null -eq $teamsApp) { throw "Failed to retrieve Microsoft Teams installer info." }

    $teamsInstallerPath = "$downloadPath\TeamsEnterprise-x64.msix"
    Write-Output "Downloading Teams MSIX from $($teamsApp.URI)..."
    Invoke-WebRequest -Uri $teamsApp.URI -OutFile $teamsInstallerPath -UseBasicParsing

    if (!(Test-Path $teamsInstallerPath)) { throw "Failed to download Microsoft Teams installer." }

    # --- Remove Old Teams Packages ---
    Write-Output "Removing any existing Teams AppX packages..."
    Get-AppxPackage | Where-Object { $_.PackageFamilyName -eq "MSTeams_8wekyb3d8bbwe" } | Remove-AppxPackage -ErrorAction SilentlyContinue

    # --- Install Teams ---
    Write-Output "Installing Microsoft Teams MSIX package..."
    Add-AppxProvisionedPackage -Online -PackagePath $teamsInstallerPath -SkipLicense

    # --- Set Registry Key for AVD/WVD (IsWVDEnvironment) ---
    Write-Output "Setting IsWVDEnvironment registry key..."
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Teams" -Force -ErrorAction SilentlyContinue | Out-Null
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Teams" -Name "IsWVDEnvironment" -Value 1 -PropertyType DWord -Force

    # --- Configure Auto-Start and Open-in-Background ---
    Write-Output "Configuring Teams auto-start for new users..."
    $defaultProfilePath = "C:\Users\Default\AppData\Local\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams"
    New-Item -Path $defaultProfilePath -ItemType Directory -Force | Out-Null

    $appSettingsPath = Join-Path $defaultProfilePath "app_settings.json"
    @{
        open_app_in_background = $true
        language = "en-US"
    } | ConvertTo-Json | Set-Content -Path $appSettingsPath -Force

    Write-Output "Setting Teams StartupTask registry key..."
    $startupTaskPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\AppModel\StateChange\PackageList\MSTeams_8wekyb3d8bbwe"
    New-Item -Path $startupTaskPath -Force -ErrorAction SilentlyContinue | Out-Null
    New-ItemProperty -Path $startupTaskPath -Name "State" -Value 1 -PropertyType DWord -Force

    # --- Install Teams Outlook Meeting Add-in ---
    Write-Output "Installing Teams Meeting Outlook Add-in..."
    $teamsAppPackage = Get-AppxPackage -Name "MSTeams_8wekyb3d8bbwe"
    if ($null -ne $teamsAppPackage) {
        $teamsInstallPath = $teamsAppPackage.InstallLocation
        $addinInstaller = Get-ChildItem -Path $teamsInstallPath -Recurse -Include "MicrosoftTeamsMeetingAddinInstaller.msi" -ErrorAction SilentlyContinue | Select-Object -First 1

        if ($addinInstaller) {
            Start-Process -FilePath "$env:SystemRoot\System32\msiexec.exe" -ArgumentList "/i `"$($addinInstaller.FullName)`" ALLUSERS=1 /quiet /norestart" -Wait -NoNewWindow
            Write-Output "Teams Meeting Outlook Add-in installed successfully."
        }
        else {
            Write-Warning "Could not locate Teams Meeting Add-in installer. Skipping add-in installation."
        }
    }
    else {
        Write-Warning "Teams package not found. Cannot install Meeting Add-in."
    }

    # --- Clean Up ---
    Write-Output "Cleaning up temporary files..."
    Remove-Item -Path $downloadPath -Recurse -Force -ErrorAction SilentlyContinue

    Write-Output "Removing Evergreen module..."
    Uninstall-Module -Name Evergreen -Force -AllVersions -ErrorAction SilentlyContinue

    Write-Output "Microsoft Teams installation and configuration completed successfully."
}
catch {
    Write-Error "Failed during Microsoft Teams installation: $($_.Exception.Message)"
}
