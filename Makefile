# Makefile for installing the Bash for Linux/WSL and PowerShell profile Windows
# For Windows 10/11 gnuwin32 is required for the make command.

# The following variables are used to set the install location for the bash and
# powershell profiles. The default location is the user's home directory, however
# for Linux the install needs to be in the /etc/skel plus the /root directories.
SKEL := /etc/skel
ROOT := /root
HOME := $(shell echo ~)

# Set the shell to bash
SHELL := /bin/bash

# List of files to be installed
BASH_FILES := .dir_colors .less .bash_logout .profile .bashrc
NANO_FILES := .nanorc

# The following variables are used to set the install location for the powershell
# profile. The default location is the user's home directory i.e. $HOME. Set the
# default location for the PowerShell profile.ps1 to be installed Documents/Powershell.
POWERSHELL_FILES := profile.ps1
POWERSHELL_DIR := $(HOME)/Documents/WindowsPowerShell

# Starship prompt configuration file.
STARSHIP_FILES := src/starship.toml

# Source location.
SRC_LINUX := src/linux
SRC_WINDOWS := src/windows

FONT_URL := https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraMono.zip

FONT_DIR_LINUX := /usr/local/share/fonts/FiraMono
FONT_DIR_WINDOWS := C:\Windows\Fonts

.PHONY: linux windows

# Check if the user is running WSL: any value returned means WSL is running.
ifeq ($(shell echo WSL_DISTRO_NAME), WSL_DISTRO_NAME)
WSL := true
endif

font-linux:

# Check if WSL variable is set, if so then do not install the fonts, but ask the user to
# install the fonts using `make font`.
ifeq ($(WSL), true)
	@echo "Do not install fonts for WSL, instead run 'make font-windows' to install the fonts."
	@exit 0
else
ifeq ($(shell whoami), root)
# Install the FiraMono fonts by downloading the latest version from github.
	@echo "Installing FiraMono fonts"
	@wget -O /tmp/FiraMono.zip $(FONT_URL)
	@mkdir -pv $(FONT_DIR_LINUX)
	@unzip -o /tmp/FiraMono.zip -d $(FONT_DIR_LINUX)
	@fc-cache -fv
endif
endif


# Install the bash profile for Linux/WSL, but for WSL do not install the fonts. Instead
# ask the user to install the font using `make font`.
linux:
	@echo "Installing bash profile for Linux/WSL"

# Install the bash profile for the default user.
	@for file in $(BASH_FILES); do \
		cp -v $(SRC_LINUX)/$$file $(HOME)/$$file; \
	done

# Install the nano profile for the default user.
	@cp -vf $(SRC_LINUX)/$(NANO_FILES) $(HOME)/$(NANO_FILES)

# if sudo was used then install the bash profile in the /etc/skel and /root directories.
ifeq ($(shell whoami), root)
	@for file in $(BASH_FILES); do \
		cp -v $(SRC_LINUX)/$$file $(SKEL)/$$file; \
	done

	@cp -vf $(SRC_LINUX)/$(NANO_FILES) $(SKEL)/$(NANO_FILES)

	@for file in $(BASH_FILES); do \
		cp -v $(SRC_LINUX)/$$file $(ROOT)/$$file; \
	done

	@cp -vf $(SRC_LINUX)/$(NANO_FILES) $(ROOT)/$(NANO_FILES)

endif

# Install the starship prompt configuration file.
	@echo "Installing starship prompt configuration file"
	@mkdir -pv $(HOME)/.config
	@cp -vf $(STARSHIP_FILES) $(HOME)/.config/starship.toml

# Install Starship prompt.

ifeq ($(shell whoami), root)
	@echo "Installing starship prompt"
	@curl -fsSL https://starship.rs/install.sh | sh -s -- -y
endif

# Call the font-linux target to install the fonts.
	@make font-linux

windows:
	@echo "Installing bash profile for Windows"
	cp -vf $(SRC_WINDOWS)/$(POWERSHELL_FILES) $(POWERSHELL_DIR)/$(POWERSHELL_FILES)
	@mkdir -pv $(HOME)/.config
	cp -vf $(STARSHIP_FILES) $(HOME)/.config$(STARSHIP_FILES)

# Use winget to install Starship prompt.
	@echo "Installing starship prompt"
	@winget install starship

# Install the FiraMono fonts by downloading the latest version from github using
# PowerShell commands.
	@echo "Installing FiraMono fonts"
	@powershell -Command "Invoke-WebRequest -Uri $(FONT_URL) -OutFile C:\Windows\Temp\FiraMono.zip"
	@powershell -Command "Expand-Archive -Path C:\Windows\Temp\FiraMono.zip -DestinationPath $(FONT_DIR_WINDOWS)"
	@powershell -Command "Remove-Item C:\Windows\Temp\FiraMono.zip"
	@powershell -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser"
	@powershell -Command "Update-FontCache"
