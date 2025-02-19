#!/bin/bash
clear
echo "==TGGs Debian 12 NVIDIA INSTALLER=="
echo "Führe Installation unter Verwendung von 'su -' als Rootuser aus!"
echo "Sofern kein Rootuser angelegt ist, bitte Script 'nv_debian_upgrade_sudo.sh' verwenden!"
# Repository um contrib und non-free erweitern
echo "Füge Standardrepositories die Zweige 'contrib' und 'non-free' hinzu...
apt-add-repository contrib non-free -y >/dev/null 2>&1

# Backports aktivieren
echo "Aktiviere Bookworm-Backports..."
REPO="deb http://deb.debian.org/debian bookworm-backports main contrib non-free non-free-firmware"
SOURCE_FILE="/etc/apt/sources.list"

if grep -qF "$REPO" "$SOURCE_FILE" 2>/dev/null || grep -qF "$REPO" /etc/apt/sources.list.d/*.list 2>/dev/null; then
    echo "Das Repository ist bereits eingetragen. Überspringe diesen Schritt..." >/dev/null
else
    echo "Das Repository ist nicht eingetragen. Es wird hinzugefügt..." >/dev/null
    echo "$REPO" | tee -a "$SOURCE_FILE" >/dev/null 2>&1
fi

# System aktualisieren und Kernel installieren
echo "Aktualisiere Paketquellen..."
apt update >/dev/null 2>&1
echo "Installiere aktuelles Backportskernel & Header, DKMS und Firmware-nonfree..."
apt install -y linux-image-6.12.9+bpo-amd64 linux-headers-6.12.9+bpo-amd64 dkms firmware-misc-nonfree firmware-linux-nonfree >/dev/null 2>&1

clear
echo "Hole NVIDIA Keyring von NVIDIA-Server..."
# Nvidia Keyring holen
wget https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/cuda-keyring_1.1-1_all.deb >/dev/null 2>&1
sleep 2

# Keyring installieren
echo "Installiere NVIDIA Keyring..."
dpkg -i cuda-keyring_1.1-1_all.deb 2>&1
sleep 2
apt update >/dev/null 2>&1
apt -f install >/dev/null 2>&1
clear

# NVIDIA Repository eintragen
echo "Trage NVIDIA-CUDA Repository in /etc/apt/sources.list.d/ ein"
echo "deb [signed-by=/usr/share/keyrings/cuda-archive-keyring.gpg] https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/ /" \
    | tee /etc/apt/sources.list.d/cuda-debian12-x86_64.list >/dev/null 2>&1
sleep 2

# Driverauswahl
clear
echo "== DRIVERAUSWAHL =="
echo "Welche Nvidia-Treiber möchtest du installieren?"
echo "1) Offener Treiber (nvidia-open)"
echo "2) Proprietärer Treiber mit CUDA (nvidia-driver)"
echo "3) Abbrechen"

read -p "Bitte wähle eine Option (1/2/3): " choice

case $choice in
    1)
        echo "Installiere den offenen Nvidia-Treiber..."
        apt install -y nvidia-open >/dev/null 2>&1
        echo "Bitte System neu starten..."
        ;;
    2)
        echo "Installiere den proprietären Nvidia-Treiber mit CUDA..."
        apt install -y nvidia-driver >/dev/null 2>&1
        echo "Bitte System neu starten..."
        ;;
    3)
        echo "Installation abgebrochen." 
        exit 0
        ;;
    *)
        echo "Ungültige Eingabe. Bitte wähle 1, 2 oder 3."
        exit 1
        ;;
esac
