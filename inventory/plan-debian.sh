#!/usr/bin/env bash
# Plan generado por autoapp 1.0.0 para: debian
# Fecha: 2026-11-27T04:16:36Z
# Espacio libre detectado: 292.71 GiB
# REVISAR ANTES DE EJECUTAR. Este script NO se ejecuta automáticamente.
set -Eeuo pipefail

echo "[plan] Destino: debian"
PKGS=(
  "7zip"
  "abiword"
  "adb"
  "aircrack-ng"
  "alien"
  "amule"
  "anydesk"
  "apt-transport-https"
  "apt-utils"
  "aria2"
  "arj"
  "autoconf"
  "automake"
  "bash"
  "bc"
  "bleachbit"
  "brasero"
  "brave-browser"
  "btop"
  "btrfs-progs"
  "build-essential"
  "bzip2"
  "ca-certificates"
  "calibre"
  "ccd2iso"
  "cdrdao"
  "cloudflare-warp"
  "cmake"
  "configuradorfnmt"
  "coreutils"
  "cpio"
  "cpu-x"
  "cubic"
  "curl"
  "dash"
  "dbus"
  "debootstrap"
  "deemix-gui"
  "default-jdk-headless"
  "dialog"
  "diffutils"
  "discord"
  "dkms"
  "docker-ce"
  "docker-compose-plugin"
  "doomseeker"
  "dosbox"
  "dosfstools"
  "droidcam-client"
  "dwarves"
  "e2fsprogs"
  "efibootmgr"
  "element-desktop"
  "elinks"
  "extrepo"
  "fail2ban"
  "fakeroot"
  "fastfetch"
  "fdisk"
  "ffmpeg"
  "filezilla"
  "findutils"
  "flashrom"
  "flatpak"
  "flex"
  "fonts-liberation"
  "g++"
  "gawk"
  "gcc"
  "gh"
  "gimp-help-es"
  "git"
  "glab"
  "gnat"
  "gnumeric"
  "gnupg"
  "golang-go"
  "google-chrome-stable"
  "google-earth-pro-stable"
  "gparted"
  "grim"
  "grub-common"
  "gscan2pdf"
  "hardinfo"
  "hostname"
  "htop"
  "httrack"
  "hunspell-es"
  "hw-probe"
  "inotify-tools"
  "intltool"
  "java-common"
  "jq"
  "k3b"
  "kazam"
  "kdeconnect"
  "keepassxc"
  "kpartx"
  "labwc"
  "language-pack-es"
  "lhasa"
  "libasound2-dev"
  "libc6"
  "lsof"
  "mtools"
  "ncdu"
  "ninja-build"
  "openssl"
  "pkg-config"
  "python3"
  "python3-pip"
  "qemu-utils"
  "rsync"
  "samba"
  "snapd"
  "tar"
  "texlive-latex-extra"
  "unzip"
  "vlc"
  "wget"
  "xz-utils"
)
apt-get update
apt-get install -y --no-install-recommends "${PKGS[@]}"

printf "400\n" "[plan] NO PORTABLE / REVISION MANUAL ():" >&2
cat <<'EOF' >&2
# Estos elementos no tienen equivalente automatico:
# - amule-emc (sin equivalente portable)
# - amule-utils-gui (sin equivalente portable)
# - arch-test (sin equivalente portable)
# - asciidoc (sin equivalente portable)
# - aspell-es (sin equivalente portable)
# - aspnetcore-runtime-dbg-10.0 (sin equivalente portable)
# - autofirma (sin equivalente portable)
# - bchunk (sin equivalente portable)
# - bindgen (sin equivalente portable)
# - binfmt-support (sin equivalente portable)
# - bison (sin equivalente portable)
# - bmap-tools (sin equivalente portable)
# - bsd-mailx (sin equivalente portable)
# - bsdutils (sin equivalente portable)
# - bully (sin equivalente portable)
# - cage (sin equivalente portable)
# - cgpt (sin equivalente portable)
# - cgroup-tools (sin equivalente portable)
# - chocolate-doom (sin equivalente portable)
# - cifs-utils (sin equivalente portable)
# - clang-19 (sin equivalente portable)
# - containerd.io (sin equivalente portable)
# - dctrl-tools (sin equivalente portable)
# - debhelper (sin equivalente portable)
# - debian-archive-keyring (sin equivalente portable)
# - debos (sin equivalente portable)
# - debsums (sin equivalente portable)
# - device-tree-compiler (sin equivalente portable)
# - devscripts (sin equivalente portable)
# - docker-buildx-plugin (sin equivalente portable)
# - docker-ce-cli (sin equivalente portable)
# - docker-ce-rootless-extras (sin equivalente portable)
# - docker-desktop (sin equivalente portable)
# - doomseeker-chocolatedoom (sin equivalente portable)
# - doomseeker-turok2ex (sin equivalente portable)
# - doomseeker-zandronum (sin equivalente portable)
# - dotnet-runtime-dbg-10.0 (sin equivalente portable)
# - dotnet-sdk-10.0 (sin equivalente portable)
# - dotnet-sdk-dbg-10.0 (sin equivalente portable)
# - dpkg-dev (sin equivalente portable)
# - eatmydata (sin equivalente portable)
# - ecwolf (sin equivalente portable)
# - equivs (sin equivalente portable)
# - espeak-ng (sin equivalente portable)
# - fonts-crosextra-carlito (sin equivalente portable)
# - fonts-freefont-ttf (sin equivalente portable)
# - fonts-ipafont-gothic (sin equivalente portable)
# - fonts-noto-color-emoji (sin equivalente portable)
# - fonts-tlwg-loma-otf (sin equivalente portable)
# - fonts-unifont (sin equivalente portable)
# - fonts-wqy-zenhei (sin equivalente portable)
# - g++-multilib (sin equivalente portable)
# - gcc-arm-none-eabi (sin equivalente portable)
# - gcc-multilib (sin equivalente portable)
# - gmp-ecm (sin equivalente portable)
# - gnome-boxes (sin equivalente portable)
# - gnumeric-plugins-extra (sin equivalente portable)
# - golang-1.26 (sin equivalente portable)
# - grep (sin equivalente portable)
# - grml-debootstrap (sin equivalente portable)
# - grub-efi-amd64 (sin equivalente portable)
# - grub-efi-amd64-bin (sin equivalente portable)
# - grub-efi-amd64-signed (sin equivalente portable)
# - grub-pc-bin (sin equivalente portable)
# - gzdoom (sin equivalente portable)
# - hyphen-es (sin equivalente portable)
# - init (sin equivalente portable)
# - inotify-hookable (sin equivalente portable)
# - inotify-info (sin equivalente portable)
# - isolinux (sin equivalente portable)
# - joy2key (sin equivalente portable)
# - kali-archive-keyring (sin equivalente portable)
# - kmod (sin equivalente portable)
# - language-pack-gnome-es (sin equivalente portable)
# - libasound2-data (sin equivalente portable)
# - libasound2-dev:i386 (sin equivalente portable)
# - libasound2-doc (sin equivalente portable)
# - libasound2-plugin-bluez (sin equivalente portable)
# - libasound2-plugin-equal (sin equivalente portable)
# - libasound2-plugins (sin equivalente portable)
# - libasound2-plugins:i386 (sin equivalente portable)
# - libasound2-plugin-smixer (sin equivalente portable)
# - libasound2-plugin-smixer:i386 (sin equivalente portable)
# - libasound2t64 (sin equivalente portable)
# - libasound2t64:i386 (sin equivalente portable)
# - libatk1.0-0t64 (sin equivalente portable)
# - libatk-bridge2.0-0t64 (sin equivalente portable)
# - libatspi2.0-0t64 (sin equivalente portable)
# - libaudit-dev (sin equivalente portable)
# - libavcodec-dev (sin equivalente portable)
# - libavdevice-dev (sin equivalente portable)
# - libavformat-dev (sin equivalente portable)
# - libavutil-dev (sin equivalente portable)
# - libayatana-appindicator-glib2 (sin equivalente portable)
# - libc6:i386 (sin equivalente portable)
# - libcairo2 (sin equivalente portable)
# - libcaja-extension-dev (sin equivalente portable)
# - libcap-dev (sin equivalente portable)
# - libcups2t64 (sin equivalente portable)
# - libdbus-1-3 (sin equivalente portable)
# - libdebuginfod-dev (sin equivalente portable)
# - libdrm2 (sin equivalente portable)
# - libdw-dev (sin equivalente portable)
# - libegl1 (sin equivalente portable)
# - libegl1:i386 (sin equivalente portable)
# - libelf-dev (sin equivalente portable)
# - libfontconfig1 (sin equivalente portable)
# - libfreetype6 (sin equivalente portable)
# - libgbm1 (sin equivalente portable)
# - libgbm1:i386 (sin equivalente portable)
# - libgl1 (sin equivalente portable)
# - libgl1:i386 (sin equivalente portable)
# - libgl1-mesa-dri (sin equivalente portable)
# - libgl1-mesa-dri:i386 (sin equivalente portable)
# - libglib2.0-0t64 (sin equivalente portable)
# - libglu1-mesa-dev (sin equivalente portable)
# - libgnutls28-dev (sin equivalente portable)
# - libgtk-3-dev (sin equivalente portable)
# - libgtk-layer-shell0 (sin equivalente portable)
# - libiberty-dev (sin equivalente portable)
# - libjson-glib-dev (sin equivalente portable)
# - liblzma-dev (sin equivalente portable)
# - libmagic-dev (sin equivalente portable)
# - libncurses-dev (sin equivalente portable)
# - libnettle8t64 (sin equivalente portable)
# - libnettle8t64:i386 (sin equivalente portable)
# - libnewt-dev (sin equivalente portable)
# - libnspr4 (sin equivalente portable)
# - libnss3 (sin equivalente portable)
# - libnuma-dev (sin equivalente portable)
# - libopenal-dev (sin equivalente portable)
# - libpango-1.0-0 (sin equivalente portable)
# - libpcap-dev (sin equivalente portable)
# - libpci-dev (sin equivalente portable)
# - libpkcs11-fnmtdnie (sin equivalente portable)
# - libpython3-dev (sin equivalente portable)
# - libreoffice-help-es (sin equivalente portable)
# - libreoffice-l10n-es (sin equivalente portable)
# - librewolf (sin equivalente portable)
# - libsdl2-2.0-0 (sin equivalente portable)
# - libsdl2-2.0-0:i386 (sin equivalente portable)
# - libsdl2-dev:i386 (sin equivalente portable)
# - libsdl3-0 (sin equivalente portable)
# - libsdl3-dev (sin equivalente portable)
# - libspa-0.2-libcamera (sin equivalente portable)
# - libssl-dev (sin equivalente portable)
# - libstdc++-13-dev (sin equivalente portable)
# - libstdc++-15-dev (sin equivalente portable)
# - libswresample-dev (sin equivalente portable)
# - libtool (sin equivalente portable)
# - libtraceevent-dev (sin equivalente portable)
# - libtracefs-dev (sin equivalente portable)
# - libudev1:i386 (sin equivalente portable)
# - libudev-dev (sin equivalente portable)
# - libunwind-dev (sin equivalente portable)
# - libusb-1.0-0 (sin equivalente portable)
# - libusb-1.0-0-dev (sin equivalente portable)
# - libv4l-dev (sin equivalente portable)
# - libvdpau-va-gl1 (sin equivalente portable)
# - libvlccore9 (sin equivalente portable)
# - libwxgtk3.2-dev (sin equivalente portable)
# - libx11-6 (sin equivalente portable)
# - libx11-6:i386 (sin equivalente portable)
# - libxcb1 (sin equivalente portable)
# - libxcomposite1 (sin equivalente portable)
# - libxcursor1:i386 (sin equivalente portable)
# - libxdamage1 (sin equivalente portable)
# - libxext6 (sin equivalente portable)
# - libxext6:i386 (sin equivalente portable)
# - libxfixes3 (sin equivalente portable)
# - libxfixes3:i386 (sin equivalente portable)
# - libxi6:i386 (sin equivalente portable)
# - libxkbcommon0 (sin equivalente portable)
# - libxrandr2 (sin equivalente portable)
# - libxrandr2:i386 (sin equivalente portable)
# - libxrender1:i386 (sin equivalente portable)
# - linux-generic (sin equivalente portable)
# - linux-headers-7.0.0-15-generic (sin equivalente portable)
# - live-build (sin equivalente portable)
# - lm-sensors (sin equivalente portable)
# - lsb-release (sin equivalente portable)
# - lynx (sin equivalente portable)
# - lzma (sin equivalente portable)
# - lzop (sin equivalente portable)
# - m4 (sin equivalente portable)
# - make (sin equivalente portable)
# - makedumpfile (sin equivalente portable)
# - mate-common (sin equivalente portable)
# - mate-submodules-source (sin equivalente portable)
# - mednaffe (sin equivalente portable)
# - memtest86+ (sin equivalente portable)
# - meson (sin equivalente portable)
# - microsoft-edge-stable (sin equivalente portable)
# - midori (sin equivalente portable)
# - mingw-w64 (sin equivalente portable)
# - mkusb (sin equivalente portable)
# - mmdebstrap (sin equivalente portable)
# - molotov (sin equivalente portable)
# - mono-devel (sin equivalente portable)
# - monodoc-hexbox-manual (sin equivalente portable)
# - monodoc-opentk-manual (sin equivalente portable)
# - mono-libraries (sin equivalente portable)
# - mono-libraries-debug (sin equivalente portable)
# - monopd (sin equivalente portable)
# - mono-runtime (sin equivalente portable)
# - mupen64plus-qt (sin equivalente portable)
# - mythes-es (sin equivalente portable)
# - nala (sin equivalente portable)
# - ncurses-base (sin equivalente portable)
# - ncurses-bin (sin equivalente portable)
# - nsis (sin equivalente portable)
# - nsis-common (sin equivalente portable)
# - nsis-doc (sin equivalente portable)
# - nsis-pluginapi (sin equivalente portable)
# - obs-studio (sin equivalente portable)
# - openarena (sin equivalente portable)
# - openssh-server (sin equivalente portable)
# - open-video-downloader (sin equivalente portable)
# - opera-stable (sin equivalente portable)
# - packages-microsoft-prod (sin equivalente portable)
# - packer (sin equivalente portable)
# - packettracer (sin equivalente portable)
# - pacstall (sin equivalente portable)
# - pahole (sin equivalente portable)
# - parted (sin equivalente portable)
# - patch (sin equivalente portable)
# - pdftk-java (sin equivalente portable)
# - perl (sin equivalente portable)
# - pipewire-alsa:i386 (sin equivalente portable)
# - pipewire-audio-client-libraries (sin equivalente portable)
# - pipewire-module-xrdp (sin equivalente portable)
# - pipx (sin equivalente portable)
# - pixz (sin equivalente portable)
# - pkgconf (sin equivalente portable)
# - pokemmo-installer (sin equivalente portable)
# - powershell (sin equivalente portable)
# - pulseaudio-utils:i386 (sin equivalente portable)
# - python3-apt (sin equivalente portable)
# - python3-dev (sin equivalente portable)
# - python3-distupgrade (sin equivalente portable)
# - python3-docutils (sin equivalente portable)
# - python3-psutil (sin equivalente portable)
# - python3-setuptools (sin equivalente portable)
# - python3-simple-cdd (sin equivalente portable)
# - python3-virtualenv (sin equivalente portable)
# - python-is-python3 (sin equivalente portable)
# - qemu-system (sin equivalente portable)
# - qemu-system-arm (sin equivalente portable)
# - qemu-system-common (sin equivalente portable)
# - qemu-system-data (sin equivalente portable)
# - qemu-system-gui (sin equivalente portable)
# - qemu-system-mips (sin equivalente portable)
# - qemu-system-misc (sin equivalente portable)
# - qemu-system-modules-opengl (sin equivalente portable)
# - qemu-system-modules-spice (sin equivalente portable)
# - qemu-system-ppc (sin equivalente portable)
# - qemu-system-riscv (sin equivalente portable)
# - qemu-system-s390x (sin equivalente portable)
# - qemu-system-sparc (sin equivalente portable)
# - qemu-system-x86 (sin equivalente portable)
# - qemu-system-x86-xen (sin equivalente portable)
# - qemu-system-xen (sin equivalente portable)
# - qemu-user (sin equivalente portable)
# - qemu-user-binfmt (sin equivalente portable)
# - quickemu (sin equivalente portable)
# - rar (sin equivalente portable)
# - realvnc-vnc-server (sin equivalente portable)
# - realvnc-vnc-viewer (sin equivalente portable)
# - reaver (sin equivalente portable)
# - reprepro (sin equivalente portable)
# - ripgrep (sin equivalente portable)
# - rustc (sin equivalente portable)
# - rustdesk (sin equivalente portable)
# - rustfmt (sin equivalente portable)
# - rust-src (sin equivalente portable)
# - seahorse (sin equivalente portable)
# - sharutils (sin equivalente portable)
# - shellcheck (sin equivalente portable)
# - shim-signed (sin equivalente portable)
# - signal-desktop (sin equivalente portable)
# - simple-cdd (sin equivalente portable)
# - slurp (sin equivalente portable)
# - smbclient (sin equivalente portable)
# - software-properties-common (sin equivalente portable)
# - spdx-licenses (sin equivalente portable)
# - speedtest-cli (sin equivalente portable)
# - spotiflyer (sin equivalente portable)
# - spotify-client (sin equivalente portable)
# - squashfs-tools (sin equivalente portable)
# - steam-launcher (sin equivalente portable)
# - steam-libs (sin equivalente portable)
# - steam-libs-amd64 (sin equivalente portable)
# - steam-libs-i386:i386 (sin equivalente portable)
# - swapspace (sin equivalente portable)
# - swaybg (sin equivalente portable)
# - swayidle (sin equivalente portable)
# - swaylock (sin equivalente portable)
# - sweeper (sin equivalente portable)
# - swig (sin equivalente portable)
# - synaptic (sin equivalente portable)
# - syslinux (sin equivalente portable)
# - syslinux-common (sin equivalente portable)
# - systemd-container (sin equivalente portable)
# - systemd-resolved (sin equivalente portable)
# - tasksel (sin equivalente portable)
# - teamviewer (sin equivalente portable)
# - tesseract-ocr-spa (sin equivalente portable)
# - texlive-fonts-extra (sin equivalente portable)
# - texlive-luatex (sin equivalente portable)
# - texlive-xetex (sin equivalente portable)
# - timeshift (sin equivalente portable)
# - timidity (sin equivalente portable)
# - timidity-daemon (sin equivalente portable)
# - timidity-el (sin equivalente portable)
# - timidity-interfaces-extra (sin equivalente portable)
# - topgrade (sin equivalente portable)
# - torbrowser-launcher (sin equivalente portable)
# - ttf-mscorefonts-installer (sin equivalente portable)
# - typecatcher (sin equivalente portable)
# - u-boot-tools (sin equivalente portable)
# - ubuntu-keyring (sin equivalente portable)
# - ubuntu-minimal (sin equivalente portable)
# - ubuntu-release-upgrader-core (sin equivalente portable)
# - ubuntu-release-upgrader-gtk (sin equivalente portable)
# - ubuntu-restricted-addons (sin equivalente portable)
# - ubuntu-restricted-extras (sin equivalente portable)
# - ubuntu-standard (sin equivalente portable)
# - uidmap (sin equivalente portable)
# - unar (sin equivalente portable)
# - unrar (sin equivalente portable)
# - unrar-free (sin equivalente portable)
# - util-linux (sin equivalente portable)
# - uuid-dev (sin equivalente portable)
# - uuid-runtime (sin equivalente portable)
# - vagrant (sin equivalente portable)
# - variety (sin equivalente portable)
# - vboot-kernel-utils (sin equivalente portable)
# - vboot-utils (sin equivalente portable)
# - virt-manager (sin equivalente portable)
# - virtualbox (sin equivalente portable)
# - virtualbox-ext-pack (sin equivalente portable)
# - virtualbox-guest-additions-iso (sin equivalente portable)
# - vlc-bin (sin equivalente portable)
# - vlc-data (sin equivalente portable)
# - vlc-l10n (sin equivalente portable)
# - vlc-plugin-access-extra (sin equivalente portable)
# - vlc-plugin-base (sin equivalente portable)
# - vlc-plugin-bittorrent (sin equivalente portable)
# - vlc-plugin-fluidsynth (sin equivalente portable)
# - vlc-plugin-jack (sin equivalente portable)
# - vlc-plugin-notify (sin equivalente portable)
# - vlc-plugin-pipewire (sin equivalente portable)
# - vlc-plugin-qt (sin equivalente portable)
# - vlc-plugin-samba (sin equivalente portable)
# - vlc-plugin-skins2 (sin equivalente portable)
# - vlc-plugin-svg (sin equivalente portable)
# - vlc-plugin-video-output (sin equivalente portable)
# - vlc-plugin-video-splitter (sin equivalente portable)
# - vlc-plugin-visualization (sin equivalente portable)
# - w3m (sin equivalente portable)
# - warp-terminal (sin equivalente portable)
# - waydroid (sin equivalente portable)
# - webhttrack (sin equivalente portable)
# - weylus (sin equivalente portable)
# - wifite (sin equivalente portable)
# - winbind (sin equivalente portable)
# - windows95 (sin equivalente portable)
# - windscribe (sin equivalente portable)
# - wine-binfmt (sin equivalente portable)
# - winehq-devel (sin equivalente portable)
# - winetricks (sin equivalente portable)
# - wireshark (sin equivalente portable)
# - wl-clipboard (sin equivalente portable)
# - wlr-randr (sin equivalente portable)
# - wpasupplicant (sin equivalente portable)
# - wsdd (sin equivalente portable)
# - wspanish (sin equivalente portable)
# - wtmpdb (sin equivalente portable)
# - xdg-desktop-portal-wlr (sin equivalente portable)
# - xfce-polkit (sin equivalente portable)
# - xfonts-100dpi (sin equivalente portable)
# - xfonts-75dpi (sin equivalente portable)
# - xfonts-base (sin equivalente portable)
# - xfonts-cyrillic (sin equivalente portable)
# - xfonts-scalable (sin equivalente portable)
# - xmlto (sin equivalente portable)
# - xpdf (sin equivalente portable)
# - xrdp (sin equivalente portable)
# - xubuntu-desktop (sin equivalente portable)
# - xubuntu-desktop-minimal (sin equivalente portable)
# - xvfb (sin equivalente portable)
# - xwayland (sin equivalente portable)
# - yelp-tools (sin equivalente portable)
# - zandronum (sin equivalente portable)
# - zerofree (sin equivalente portable)
# - zlib1g-dev (sin equivalente portable)
# - z-library (sin equivalente portable)
# - zoom (sin equivalente portable)
# - zstd (sin equivalente portable)
# - zsync (sin equivalente portable)
EOF

echo "[plan] Finalizado."
