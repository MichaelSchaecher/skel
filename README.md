<!-- Use html element to display title and what the repo is about. -->
<div>
    <h1 align="center">Starship Prompt Config</h1>
    <p align="center">A custom config for the Starship Prompt.</p>
</div>

## About

This is a my custom config for the [Starship Prompt](https://starship.rs/). I've disabled most of the modules for displaying information about source control. I find that to much info is pointless and I should already know what source control I'm working with anyways.

### Features

- FiraCode Nerd Font Mono
- Custom bashrc, profile and dir_colors
- Custom Starship Prompt toml config

## Installation

To install for both Linux and Windows, make needs to installed. On Windows via `winget install "GnuWin32.Make"` and for Debian/Ubuntu via `sudo apt install -y build-essential`.

### Linux

It is recommended to install the Starship Prompt globally that is why running `make install` will not install the fonts nor Starship Prompt. To install the full configuration run `sudo make install`.

### Windows

To setup Starship Prompt on Windows you need to manually copy the `starship.toml` and `profile.ps1` files. Don't forget to create the directories first.

```powershell
# Create the Starship Prompt config directory
New-Item -Path $env:USERPROFILE\.config\starship -ItemType Directory -Force
```

```powershell
# Copy the starship.toml file to the Starship Prompt config directory
Copy-Item -Path .\src\windows\starship.toml -Destination $env:USERPROFILE\.config\starship.toml
```

Copy the `profile.ps1` file to the PowerShell profile directory, create the directory first and then create symbolic link to the `profile.ps1` file.

```powershell
# Create the PowerShell profile directory
New-Item -Path $env:USERPROFILE\Documents\WindowsPowerShell -ItemType Directory -Force
```

```powershell
# Copy the profile.ps1 file to the PowerShell profile directory
Copy-Item -Path .\src\windows\profile.ps1 -Destination $env:USERPROFILE\Documents\PowerShell\profile.ps1
```

```powershell
# Create symbolic link to the profile.ps1 file
New-Item -Path $env:USERPROFILE\Documents\WindowsPowerShell\profile.ps1 -ItemType SymbolicLink -Value $env:USERPROFILE\Documents\PowerShell\profile.ps1
```

Install the fonts by copying then to the `C:\Windows\Fonts` directory.

```powershell
# Copy the fonts to the Windows fonts directory
Copy-Item -Path .\src\windows\fonts\* -Destination C:\Windows\Fonts -Force
```
