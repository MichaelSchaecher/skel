<!-- Use html element to display title and what the repo is about. -->
<div align="center" >
    <h1 style="color: rgb(175,50,100); font-size: 3em; font-weight: bold;">
        Dot Files</h1>
    <h3>
        <strong>My custom dot files for Debian/Ubuntu and Windows using Starship Prompt</strong>
    </h3>
</div>

- [About](#about)
  - [Debian/Ubuntu Features](#debianubuntu-features)
  - [Windows Features](#windows-features)
- [Installation](#installation)
  - [Debian/Ubuntu](#debianubuntu)
    - [Install the fonts Linux](#install-the-fonts-linux)
    - [Install the dot files](#install-the-dot-files)
    - [Help and Web](#help-and-web)
  - [Windows](#windows)
    - [Install the fonts Windows](#install-the-fonts-windows)

## About

This is my custom dot files for Debian/Ubuntu and Windows using [Starship Prompt](https://starship.rs/). I use this dot files to make my life easier when I need to setup a new machine or reinstall my OS. I use [Starship Prompt](https://starship.rs/) because it's fast, customizable and easy to use.

### Debian/Ubuntu Features

- [x] [Starship Prompt](https://starship.rs/)
- [x] [bash](https://www.gnu.org/software/bash/)
- [x] [fish](https://fishshell.com/)
- [x] Custom aliases
- [x] Custom functions
- [x] Scrollable history with arrow keys (Up and Down)
- [x] Command history completion with Tab
- [x] Previous command search with arrow keys (Up and Down)
- [x] Hugo Static Site Generator integration

### Windows Features

- [x] [Starship Prompt](https://starship.rs/)
- [x] [PowerShell](https://docs.microsoft.com/en-us/powershell/)
- [x] Custom aliases
- [x] Custom functions for a more Linux-like experience

## Installation

### Debian/Ubuntu

#### Install the fonts Linux

```bash
sudo mkdir -v /usr/local/share/fonts/FiraCode
sudo cp -v src/fonts/FiraCode/* /usr/local/share/fonts/FiraCode/
sudo fc-cache -fv
```

#### Install the dot files

Install [Starship Prompt](https://starship.rs/) with the following command: `curl -fsSL https://starship.rs/install.sh |sudo sh -s -- --yes`. This will install Starship Prompt in `/usr/local/bin/starship`. Now clone this repository and copy the files to your home, /etc/skel and /root directories with the following commands:

```bash
git clone https://github.com/MichaelSchaecher/skell
cd skel
```

Copy the files to your home directory with the following command:

```bash
# Copy files to home directory

cp -av src/linux/._ ~/
cp -av src/linux/._ /etc/skel/
cp -av src/linux/.\* /root/
cp -av src/starship.toml ~/.config/
```

If copying the startship.toml file to ~/.config/ doesn't work, you may need to create the directory first with the following command: `mkdir -p ~/.config/`. Now you can copy the starship.toml file to ~/.config/ with the following command: `cp -av src/starship.toml ~/.config/`.

Check out the new shell: `source ~/.bashrc` and finish the installation.

Copy the files to /etc/skel and /root directories with the following commands:

```bash
sudo mkdir -v /{etc/skel,root}/.config
sudo cp -v src/starship.toml /{etc/skel,root}/.config/
sudo cp -v src/linux/.* /{etc/skel,root}/
```

#### Help and Web

A dot file for displaying help info relating to functions and aliases is included. To use it just type copy the command `cp -av src/linux/.helpful ~/` and then type `helpful` in the terminal.

Also a hidden `.web` is required for the [Starship Prompt](https://starship.rs/) to work with default font styles for most browsers. The file is created when you log into a new shell if the file doesn't exist. To create the file manually, type `touch ~/.web` in the terminal.

### Windows

#### Install the fonts Windows

```powershel
Copy-Item -Path src\fonts\FiraCode\* -Destination C:\Windows\Fonts\ -Recurse -Force
```

You may need to reopen PowerShell as an administrator to install the fonts.

Open PowerShell and install [Starship Prompt](https://starship.rs/) and git with winget:

```powershell
winget install --accept-package-agreements  --accept-package-agreements "Starship.Starship"
winget install --accept-package-agreements  --accept-package-agreements "Git.Git"
```

Clone this repository and copy the files to your home directory with the following commands:

```powershell
git clone https://github.com/MichaelSchaecher/skell
cd skel
```

Copy the files to your home directory with the following PowerShell command:

```powershell
Copy-Item -Path src\windows\* -Destination $HOME\Documents\Powershell\ -Recurse -Force
```

You may need to create the powershell directory first with the following PowerShell command: `New-Item -Path $HOME\Documents\Powershell\ -ItemType Directory`. Now you can copy the files to your home directory with the following PowerShell command: `Copy-Item -Path src\windows\* -Destination $HOME\Documents\Powershell\ -Recurse -Force`. If you are still using PowerShell 5.1, then do the following:

```powershell
Copy-Item -Path src\windows\* -Destination $HOME\Documents\WindowsPowerShell\ -Recurse -Force
```

Create and `.config` directory in your home directory and copy the starship.toml file to it with the following PowerShell commands:

```powershell
New-Item -Path $HOME\.config -ItemType Directory
Copy-Item -Path src\starship.toml -Destination $HOME\.config\ -Force
```

Reload your PowerShell profile with the following command:

```powershell
. $HOME\Documents\PowerShell\profile.ps1
```
