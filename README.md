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

To install the bash configuration files and Starship Prompt with the custom config, run the following command:

```bash
make linux
```

> NOTE: To install Starship Prompt you will need root access. Otherwise the only thing that will be installed is the bash configuration files for local user.

```bash
sudo make linux
```

### Windows

To install the bash configuration files and Starship Prompt with the custom config, run the following command:

```powershell
make windows
```
