#!/bin/bash

# Clear Screen
tput reset 2>/dev/null || clear

# Colours (or Colors in en_US)
RED='\033[0;31m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
BLUE='\033[0;34m'
NORMAL='\033[0m'

# Abort Function
function abort(){
    [ ! -z "$@" ] && echo -e ${RED}"${@}"${NORMAL}
    exit 1
}

# Banner
function __bannerTop() {
	echo -e \
	${GREEN}"
	██████╗░██╗░░░██╗███╗░░░███╗██████╗░██████╗░██╗░░██╗
	██╔══██╗██║░░░██║████╗░████║██╔══██╗██╔══██╗╚██╗██╔╝
	██║░░██║██║░░░██║██╔████╔██║██████╔╝██████╔╝░╚███╔╝░
	██║░░██║██║░░░██║██║╚██╔╝██║██╔═══╝░██╔══██╗░██╔██╗░
	██████╔╝╚██████╔╝██║░╚═╝░██║██║░░░░░██║░░██║██╔╝╚██╗
	╚═════╝░░╚═════╝░╚═╝░░░░░╚═╝╚═╝░░░░░╚═╝░░╚═╝╚═╝░░╚═╝
	"${NORMAL}
}

# Welcome Banner
printf "\e[32m" && __bannerTop && printf "\e[0m"

# Minor Sleep
sleep 1

if [[ "$OSTYPE" == "linux-gnu" ]]; then

    if command -v apt > /dev/null 2>&1; then

        echo -e ${PURPLE}"Ubuntu/Debian Based Distro Detected"${NORMAL}
        sleep 1
        echo -e ${BLUE}">> Enabling Universe/Multiverse Repos..."${NORMAL}
        sudo apt -y install software-properties-common
        sudo add-apt-repository -y universe
        sudo add-apt-repository -y multiverse

        echo -e ${BLUE}">> Updating apt repos..."${NORMAL}
        sudo apt -y update || abort "Setup Failed at Update!"

        echo -e ${BLUE}">> Installing Required Packages..."${NORMAL}
        # Incluído lz4 e erofs-utils para evitar falhas no dumper
        sudo apt install -y unace unrar-free zip unzip p7zip-full p7zip-rar sharutils uudeview mpack arj cabextract \
        device-tree-compiler liblzma-dev python3-pip brotli lz4 axel gawk aria2 detox cpio rename liblz4-dev \
        jq git-lfs erofs-utils || abort "Setup Failed at Install!"

    elif command -v dnf > /dev/null 2>&1; then

        echo -e ${PURPLE}"Fedora Based Distro Detected"${NORMAL}
        sleep 1
        echo -e ${BLUE}">> Installing Required Packages..."${NORMAL}
        sudo dnf install -y unace unrar zip unzip sharutils uudeview arj cabextract file-roller dtc python3-pip \
        brotli axel aria2 detox cpio lz4 python3-devel xz-devel p7zip p7zip-plugins git-lfs erofs-utils || abort "Setup Failed!"

    elif command -v pacman > /dev/null 2>&1; then

        echo -e ${PURPLE}"Arch or Arch Based Distro Detected"${NORMAL}
        sleep 1
        echo -e ${BLUE}">> Installing Required Packages..."${NORMAL}
        sudo pacman -Syyu --needed --noconfirm >/dev/null || abort "Setup Failed!"
        sudo pacman -Sy --noconfirm unace unrar p7zip sharutils uudeview arj cabextract file-roller dtc \
        brotli axel gawk aria2 detox cpio lz4 jq git-lfs erofs-utils || abort "Setup Failed!"

    fi

elif [[ "$OSTYPE" == "darwin"* ]]; then

    echo -e ${PURPLE}"macOS Detected"${NORMAL}
    sleep 1
    echo -e ${BLUE}">> Installing Required Packages..."${NORMAL}
    brew install protobuf xz brotli lz4 aria2 detox coreutils p7zip gawk git-lfs || abort "Setup Failed!"

fi

sleep 1

# Install `uv`
echo -e ${BLUE}">> Installing uv for python packages..."${NORMAL}
sleep 1
curl -sL https://astral.sh/uv/install.sh | sh || abort "Setup Failed!"

# Atualiza o PATH imediatamente para esta sessão
export PATH="$HOME/.local/bin:$PATH"

# Garante que o uv/uvx esteja disponível no .bashrc para futuras sessões
if ! grep -q ".local/bin" ~/.bashrc; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
fi

# Done!
echo -e ${GREEN}"Setup Complete! Agora você pode rodar ./dumper.sh"${NORMAL}

# Exit
exit 0
