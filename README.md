# NVIDIA-Driver Setup for Debian Bookworm

These bash scripts are intended for use with **Debian Bookworm** and an **NVIDIA GPU**.
Please only use these scripts if you are using an NVIDIA GPU.

> **Important:** You need to uninstall any previously installed NVIDIA drivers before using these scripts.

## Scripts Overview

- **nv_debian_upgrade_su.sh**: Script with German texts (echoes).
- **nv_debian_upgrade_su_eng.sh**: Script with English texts (echoes).
- **nv_debian_upgrade_sudo.sh**: Script with German texts (echoes).
- **nv_debian_upgrade_sudo_eng.sh**: Script with English texts (echoes).

## Script Functionality

The script performs the following tasks:

1. Adds `contrib` and `non-free` repositories to your `sources.list`.
2. Adds the **Backports Repository** (`bookworm-backports`).
3. Installs the latest backports kernel, kernel headers, DKMS, and firmware non-free.
4. Pulls and installs the **NVIDIA Keyring**.
5. Adds the **NVIDIA Debian 12 Repository** to `/etc/apt/sources.list.d/`.
6. Prompts you to choose between installing either the **NVIDIA Open Driver** or the **CUDA Drivers** (closed-source).

## Usage

**Please use at your own risk!**

The best use case is for a fresh installation of **Debian 12** with an **NVIDIA GPU** (which is not working properly, e.g., no boot to the desktop environment), and you want to install a more modern driver.

### Steps

After pulling the repository, you need to make the scripts executable and you have to be in the directory of the pulled scripts on your machine:
   ```bash
   chmod +x <scriptname.sh>
   ./scriptname.sh
