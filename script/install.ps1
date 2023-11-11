# Set the variables for source path for profile.ps1 and starship.toml
$profileSource = ".\src\windows\profile.ps1"
$starshipSource = ".\src\windows\starship.toml"

# Set the variables for destination path for profile.ps1 and starship.toml
$profileDestination = "$env:USERPROFILE\Documents\PowerShell\profile.ps1"
$starshipDestination = "$env:USERPROFILE\.config\starship.toml"

# The fonts to install are located in src/fonts folder.
$fontsSource = ".\src\fonts\FiraCode"

# Install the fonts in the system.
Write-Host "Installing fonts..."
$fontsDestination = "$env:WINDIR\Fonts"
Copy-Item -Path "$fontsSource\*" -Destination $fontsDestination -Force

# Copy the profile.ps1 and starship.toml to the user profile, but need to create the folder first
# if it doesn't exist.
Write-Host "Copying profile.ps1 and starship.toml to user profile..."

if (!(Test-Path -Path $profileDestination)) {
    New-Item -Path $profileDestination -ItemType Directory -Force
}

Copy-Item -Path $profileSource -Destination $profileDestination -Force

# Copy the starship.toml to the user profile, but need to create the folder first if it doesn't exist.
if (!(Test-Path -Path $starshipDestination)) {
    New-Item -Path $starshipDestination -ItemType Directory -Force
}

Copy-Item -Path $starshipSource -Destination $starshipDestination -Force

# Set the execution policy to RemoteSigned to allow the profile.ps1 to run.
Write-Host "Setting execution policy to RemoteSigned..."
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# PowerShell directory is for PowerShell 7.0 and above, but need to create a link to the PowerShell
# 5.1 directory for compatibility.
Write-Host "Creating link to PowerShell 5.1 directory..."
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\Documents\PowerShell\profile.ps1" \
    -Target "$profileDestination" -Force
