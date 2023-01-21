# ~\$HOME\Documents\PowerShell\profile.ps1

# By default PowerShell is not themed at all, and the profile script is beyond plain. I guess that it means
# that it waiting for you style to be applied, in some ways I think it is more do the fact that Microsoft
# has no style.

# I aim to fix this.

# Find out if the current user identity is elevated to admin rights.
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal $identity
$isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# Reload PowerShell profile if need. This may not work if to many changes are made to Profile.ps1 script.
function profile { & $PROFILE.CurrentUserAllHosts }

# Navigating Windows is not like Linux and at times a bit confusing.

function back  { Set-Location ..\.. }                           # Useful shortcuts for traversing directories.
function hom { Set-Location $HOME }                             # Go home from anywhere.

function local  { Set-Location HKLM: }                          # Machine drives local.
function remote  { Set-Location HKCU: }                         # Machine drives remote.

# Set title for window header to ADMIN if the user is running as Administrator.
$Host.UI.RawUI.WindowTitle = "PowerShell {0}" -f $PSVersionTable.PSVersion.ToString()
if ($isAdmin) { $Host.UI.RawUI.WindowTitle += " - ADMIN" }

# Add sudo admin functionality to command entered in PowerShell terminal.
function admin
{
    if ($args.Count -gt 0)
    {
       $argList = "& '" + $args + "'"
       Start-Process "$psHome\pwsh.exe" -Verb runAs -ArgumentList $argList
    }
    else
    {
       Start-Process "$psHome\pwsh.exe" -Verb runAs
    }
}

Set-Alias -Name sudo -Value admin

# Does the the rough equivalent of dir /s /b. For example, dirs *.png is dir /s /b *.png
function dirs {
    if ($args.Count -gt 0) {
        Get-ChildItem -Recurse -Include "$args" | Foreach-Object FullName
    } else {
        Get-ChildItem -Recurse | Foreach-Object FullName
    }
}

# Set function to act like Linux command mkdir.
function mkdir($name) { New-Item -Path $name -ItemType Directory }

function df { get-volume }                                      # List drive info.

# Touch command just Linux one used on most Linux Distrabution.
function touch($file) { "" | Out-File $file -Encoding ASCII }

# Invoke-WebRequest is kind of a miss unlike wget which is a bet easier to understand.
If (Test-Path Alias:wget) {Remove-Item Alias:wget}

function wget($url) {
        $name = ($url -split '/')[-1]
        Invoke-WebRequest -Uri "$url" -OutFile "$HOME\Downloads\$name"
}

# The sed command is nice, but also kind of a miss, this makes it simplar.
function sed($file, $find, $replace){
        (Get-Content $file).replace("$find", $replace) | Set-Content $file
}

# Unzip a standard zip archive.
function unzip ($file) {
        Write-Output("Extracting", $file, "to", $pwd)
	$fullFile = Get-ChildItem -Path $pwd -Filter .\cove.zip | ForEach-Object{$_.FullName}
        Expand-Archive -Path $fullFile -DestinationPath $pwd
}

# Find a file located int eh parent directory and up.
function find-file($name) {
        Get-ChildItem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
                $place_path = $_.directory
                Write-Output "${place_path}\${_}"
        }
}

# Easily find if a application exist with which command just like in Linux.
function which($name) { Get-Command $name | Select-Object -ExpandProperty Definition }

# Find out of process exist.
function pgrep($name) {
        if (Get-Process -erroraction 'silentlycontinue' $name) { echo 'found' }
        else { echo "process doesn't exist!" }
}

# Kill a process quickly.
function pkill($name) { Get-Process $name -ErrorAction SilentlyContinue | Stop-Process }

# Many people do not realize that Windows does have a package manager, which adds Microsoft Store
# support even if the Store app is disabled. The following is shortcuts are winget actions.
function inst ($app) {
    winget install --accept-package-agreements  --accept-package-agreements $app
}

# WSL add Linux commandline functionality to Windows, because of this having some alias's and default
# for WSL is required. Though to my liking I am foregoing installing distro's through the app and opting
# emport them.

function srch ($app) { winget search $app }                     # Search winget and MS Store for apps.

function uinst ($app) { winget uninstall $app }                 # Uninstall application.

function update () { winget upgrade --all }                     # Upgrade all installed packages.

function linux ($name) { wsl -d $name }                         # Start WSL with desired distro.

function stop-wsl () { wsl -shutdown }                          # Shutdown wsl stopping all running distro's.

function quiet-wsl ($name) { wsl --terminate $name }            # Quiet a running wsl distro.

$distroLocation = 'D:\distributions\'

function emport-distro ($name, $directory, $location) {
        if (Test-Path -Path $distroLocation\$directory) {
                wsl --import $name '$distroLocation\$directory' '$location'
        } else {
                 Write-Host "Install location doesn't exist!"
        }
}

Invoke-Expression (&starship init powershell)
