# Makefile for installing the Bash for Linux/WSL and PowerShell profile Windows
# For Windows 10/11 gnuwin32 is required for the make command.

FONT_URL := https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraMono.zip

export FONT_URL

.PHONY: linux windows

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


install:

# Run the script/install.sh script to install the bash profile.
	@script/install.sh

windows:

# Run the script/install.ps1 script to install the powershell profile.
	@powershell -ExecutionPolicy Bypass -File script\install.ps1
