# This Makefile is used to install terminal prompts and aliases and general
# theme settings. It need to run with both Windows and Linux.

# Things that need to be installed:
#
# For Windows:
# - profile.ps1 > $PROFILE/Documents/Powershell/profile.ps1
# - .config > $PROFILE/
#
# For Linux:
# - .bashrc > $HOME/.bashrc
# - .bash_logout > $HOME/.bash_logout
# - .profile > $HOME/.profile
# - .config/starship.toml > $HOME/.config/starship.toml
# - .less > $HOME/.less
# - .nanorc > $HOME/.nanorc
# - .dir_colors > $HOME/.dir_colors

# Variables for Windows
PROFILE_PATH = $(HOME)/Documents/PowerShell
PROFILE_FILE = $(PROFILE_PATH)/profile.ps1
CONFIG_PATH = $(HOME)/.config

WINDOWS_FILE = src/windows

# Variables for Linux
ROOT_PATH = /root
PROFILE_PATH = $(HOME)

LINUX_FILE = src/linux

# Variables for both Windows and Linux
STARSHIP_CONFIG_FILE = src/starship.toml

# check if the OS is Windows or Linux
ifeq ($(OS),Windows_NT)
	OS_TYPE = Windows
else
	OS_TYPE = Linux
endif

# Set variable to install Startship Prompt if it is not installed,
# this is required for both Windows and Linux.
ifeq ($(OS_TYPE),Windows)
	ifeq (, $(shell which starship))
		INSTALL_STARSHIP = 1
	else
		INSTALL_STARSHIP = 0
	endif
else
	ifeq (, $(shell which starship))
		INSTALL_STARSHIP = 1
	else
		INSTALL_STARSHIP = 0
	endif
endif

# Set Phony targets
.PHONY: install

# Install Starship Prompt
starship:
	@sh -c "curl -fsSL https://starship.rs/install.sh | sh -s -- -f"

# Install the based on the OS type Windows.
windows:
	@echo "Installing Windows files..."
	@cp -r $(WINDOWS_FILE)/profile.ps1 $(PROFILE_PATH)/

# Create $(HOME)/.config directory if it does not exist
	@mkdir -p $(CONFIG_PATH)
	@cp -vf $(STARSHIP_CONFIG_FILE) $(CONFIG_PATH)/

# Create soft link for the profile.ps1 file to Documents/WindwosPowerShell/profile.ps1
	@echo "Creating soft link for profile.ps1..."
	@New-Item -ItemType SymbolicLink -Path $(PROFILE_FILE) -Target $(PROFILE_PATH)/profile.ps1 -Force
	@echo "Done!"

# Run the starship target if Starship Prompt is not installed
ifeq ($(INSTALL_STARSHIP),1)
	@echo "Installing Starship Prompt..."
	@make starship
endif

# Install the based on the OS type Linux.
linux:

# Create $(HOME)/.config directory if it does not exist
	@mkdir -p $(CONFIG_PATH)
	@cp -vf $(STARSHIP_CONFIG_FILE) $(CONFIG_PATH)/

# Run the starship target if Starship Prompt is not installed
ifeq ($(INSTALL_STARSHIP),1)
	@echo "Installing Starship Prompt..."
	@make starship
endif

# Finish the installation
	@cp -vf $(LINUX_FILE)/.bashrc $(PROFILE_PATH)/
	@cp -vf $(LINUX_FILE)/.bash_logout $(PROFILE_PATH)/
	@cp -vf $(LINUX_FILE)/.profile $(PROFILE_PATH)/
	@cp -vf $(LINUX_FILE)/.less $(PROFILE_PATH)/
	@cp -vf $(LINUX_FILE)/.nanorc $(PROFILE_PATH)/
	@cp -vf $(LINUX_FILE)/.dir_colors $(PROFILE_PATH)/
	@cp -vf $(LINUX_FILE)/.nanorc $(PROFILE_PATH)/

# If sudo was used, copy the files to the root directory
ifeq ($(SUDO),sudo)
	@echo "Copying files to root directory..."
	@cp -vf $(LINUX_FILE)/.bashrc $(ROOT_PATH)/
	@cp -vf $(LINUX_FILE)/.bash_logout $(ROOT_PATH)/
	@cp -vf $(LINUX_FILE)/.profile $(ROOT_PATH)/
	@cp -vf $(LINUX_FILE)/.less $(ROOT_PATH)/
	@cp -vf $(LINUX_FILE)/.nanorc $(ROOT_PATH)/
	@cp -vf $(LINUX_FILE)/.dir_colors $(ROOT_PATH)/
	@cp -vf $(LINUX_FILE)/.nanorc $(ROOT_PATH)/
endif
