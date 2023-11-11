#!/bin/env bash

# This bash script is for setting up starship prompt with bash shell

# Disable useless echo ShellCheck: SC2116
HOME_DIR="$(echo ~)"

SRC_DIR=src/linux

STARSHIP_CONFIG="${SRC_DIR}/starship.toml"

NANO_CONFIG_FILE="${SRC_DIR}/.nanorc"

# Variable for list of bash config files.
BASH_CONFIG_FILES=( "${SRC_DIR}/.bashrc" "${SRC_DIR}/.bash_logout" "${SRC_DIR}/.profile"
    "${SRC_DIR}/.less" "${SRC_DIR}/.dir_colors" )

# Copy the bash config files to the home directory and if root then to /root and /etc/skel.
for file in "${BASH_CONFIG_FILES[@]}"; do
    if test "$(whoami)" = "root" ; then
        cp -va "${file}" "/root"
        cp -va "${file}" "/etc/skel"
        cp -va "${file}" "/home/${SUDO_USER}"
    else
        cp -va "${file}" "${HOME_DIR}/"
    fi
done

if test "$(whoami)" = "root" ; then
  # Copy the nano config file.
    cp -va "${NANO_CONFIG_FILE}" "/root/.config/"
    cp -va "${NANO_CONFIG_FILE}" "/etc/skel/.config/"
    cp -va "${NANO_CONFIG_FILE}" "/home/${SUDO_USER}/.config/"
else
    cp -va "${NANO_CONFIG_FILE}" "${HOME_DIR}/"
fi

# Install starship config file.
if test "$(whoami)" = "root" ; then
  # Install starship config file.
    cp -va "${STARSHIP_CONFIG}" "/root/.config/"
    cp -va "${STARSHIP_CONFIG}" "/etc/skel/.config/"
    cp -va "${STARSHIP_CONFIG}" "/home/${SUDO_USER}/.config/"
else
    cp -va "${STARSHIP_CONFIG}" "${HOME_DIR}/.config/"
fi

# Install starship prompt by downloading the latest version from github
# using command recommended by starship: but only if the user is root.
if test "$(whoami)" = "root" ; then
    curl -fsSL https://starship.rs/install.sh | sh -s -- -y

  # Download the FiraMono Nerd Font and install, but only if the user is root and
  # not running inside WSL.
  if test -z "${WSL_DISTRO_NAME}" ; then
    # Download the FiraMono Nerd Font zip file.
      cp -av "src/fonts/FiraMono" "/usr/local/share/fonts/"
  else
      echo "Running inside WSL, install FiraMono Nerd Font in Windows to use them."
  fi
else
    echo "You are not root, so you need to install starship prompt manually."
    echo "You can do this by running the following command:"
    echo "curl -fsSL https://starship.rs/install.sh | sh -s -- -y"
    echo "Then copy the starship.toml file to ~/.config/ manually."
fi

exit 0
