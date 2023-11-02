# Powershell script to install the module

# Set the location of starship.toml file and profile.ps1 file
$starshipConfig = ".\Windows\.config\starship.toml"
$profileConfig = ".\Windows\Documents\PowerShell\profile.ps1"

# Create the directory if it doesn't exist in the user's home folder.
if (!(Test-Path -Path .\config)) {
	New-Item -ItemType Directory -Path .\config
}

# Copy the starship.toml file to the user's home folder.
Copy-Item -Path $starshipConfig -Destination .\config\starship.toml

# Check if the PowerShell folder exists in the user's home folder.
if (!(Test-Path -Path .\Documents\PowerShell)) {
	New-Item -ItemType Directory -Path .\Documents\PowerShell
}

# Copy the profile.ps1 file to the user's home folder.
Copy-Item -Path $profileConfig -Destination .\Documents\PowerShell\profile.ps1

# Create the directory .\Documents\WindowsPowerShell if it doesn't exist and set a soft link to the profile.ps1 file.
# in .\Documents\PowerShell
if (!(Test-Path -Path .\Documents\WindowsPowerShell)) {
	New-Item -ItemType Directory -Path .\Documents\WindowsPowerShell
}

# Create a soft link to the profile.ps1 file in .\Documents\PowerShell
New-Item -ItemType SymbolicLink -Path .\Documents\WindowsPowerShell\profile.ps1 -Target .\Documents\PowerShell\profile.ps1
