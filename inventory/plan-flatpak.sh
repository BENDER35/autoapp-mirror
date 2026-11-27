#!/usr/bin/env bash
# Plan generado por autoapp 1.0.0 para: flatpak
# Fecha: 2026-11-27T04:17:02Z
# Espacio libre detectado: 292.71 GiB
# REVISAR ANTES DE EJECUTAR. Este script NO se ejecuta automáticamente.
set -Eeuo pipefail

echo "[plan] Destino: flatpak"

echo "[plan] Sin paquetes nativos traducidos para flatpak."

if command -v flatpak >/dev/null 2>&1; then
  flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || true
  flatpak install -y flathub "com.dosbox_x.DOSBox-X" || echo "[plan] No se pudo instalar Flatpak com.dosbox_x.DOSBox-X" >&2
  flatpak install -y flathub "com.github.Matoking.protontricks" || echo "[plan] No se pudo instalar Flatpak com.github.Matoking.protontricks" >&2
  flatpak install -y flathub "com.github.PintaProject.Pinta" || echo "[plan] No se pudo instalar Flatpak com.github.PintaProject.Pinta" >&2
  flatpak install -y flathub "com.github.tchx84.Flatseal" || echo "[plan] No se pudo instalar Flatpak com.github.tchx84.Flatseal" >&2
  flatpak install -y flathub "com.github.vkohaupt.vokoscreenNG" || echo "[plan] No se pudo instalar Flatpak com.github.vkohaupt.vokoscreenNG" >&2
  flatpak install -y flathub "com.heroicgameslauncher.hgl" || echo "[plan] No se pudo instalar Flatpak com.heroicgameslauncher.hgl" >&2
  flatpak install -y flathub "com.rafaelmardojai.Blanket" || echo "[plan] No se pudo instalar Flatpak com.rafaelmardojai.Blanket" >&2
  flatpak install -y flathub "com.stremio.Stremio" || echo "[plan] No se pudo instalar Flatpak com.stremio.Stremio" >&2
  flatpak install -y flathub "com.usebottles.bottles" || echo "[plan] No se pudo instalar Flatpak com.usebottles.bottles" >&2
  flatpak install -y flathub "eu.scarpetta.PDFMixTool" || echo "[plan] No se pudo instalar Flatpak eu.scarpetta.PDFMixTool" >&2
  flatpak install -y flathub "im.pidgin.Pidgin" || echo "[plan] No se pudo instalar Flatpak im.pidgin.Pidgin" >&2
  flatpak install -y flathub "info.urbanterror.UrbanTerror" || echo "[plan] No se pudo instalar Flatpak info.urbanterror.UrbanTerror" >&2
  flatpak install -y flathub "io.github.Faugus.faugus-launcher" || echo "[plan] No se pudo instalar Flatpak io.github.Faugus.faugus-launcher" >&2
  flatpak install -y flathub "io.github.aandrew_me.ytdn" || echo "[plan] No se pudo instalar Flatpak io.github.aandrew_me.ytdn" >&2
  flatpak install -y flathub "io.github.debasish_patra_1987.linuxthemestore" || echo "[plan] No se pudo instalar Flatpak io.github.debasish_patra_1987.linuxthemestore" >&2
  flatpak install -y flathub "io.github.fastrizwaan.WineCharm" || echo "[plan] No se pudo instalar Flatpak io.github.fastrizwaan.WineCharm" >&2
  flatpak install -y flathub "io.github.fastrizwaan.WineZGUI" || echo "[plan] No se pudo instalar Flatpak io.github.fastrizwaan.WineZGUI" >&2
  flatpak install -y flathub "io.github.flattool.Warehouse" || echo "[plan] No se pudo instalar Flatpak io.github.flattool.Warehouse" >&2
  flatpak install -y flathub "io.github.giantpinkrobots.flatsweep" || echo "[plan] No se pudo instalar Flatpak io.github.giantpinkrobots.flatsweep" >&2
  flatpak install -y flathub "io.github.intoolswetrust.JSignPdf" || echo "[plan] No se pudo instalar Flatpak io.github.intoolswetrust.JSignPdf" >&2
  flatpak install -y flathub "io.github.lavenderdotpet.LibreQuake" || echo "[plan] No se pudo instalar Flatpak io.github.lavenderdotpet.LibreQuake" >&2
  flatpak install -y flathub "io.github.vikdevelop.SaveDesktop" || echo "[plan] No se pudo instalar Flatpak io.github.vikdevelop.SaveDesktop" >&2
  flatpak install -y flathub "io.gitlab.adhami3310.Impression" || echo "[plan] No se pudo instalar Flatpak io.gitlab.adhami3310.Impression" >&2
  flatpak install -y flathub "me.sanchezrodriguez.passes" || echo "[plan] No se pudo instalar Flatpak me.sanchezrodriguez.passes" >&2
  flatpak install -y flathub "net._86box._86Box" || echo "[plan] No se pudo instalar Flatpak net._86box._86Box" >&2
  flatpak install -y flathub "net.cubers.assault.AssaultCube" || echo "[plan] No se pudo instalar Flatpak net.cubers.assault.AssaultCube" >&2
  flatpak install -y flathub "net.davidotek.pupgui2" || echo "[plan] No se pudo instalar Flatpak net.davidotek.pupgui2" >&2
  flatpak install -y flathub "net.lutris.Lutris" || echo "[plan] No se pudo instalar Flatpak net.lutris.Lutris" >&2
  flatpak install -y flathub "net.waterfox.waterfox" || echo "[plan] No se pudo instalar Flatpak net.waterfox.waterfox" >&2
  flatpak install -y flathub "org.DolphinEmu.dolphin-emu" || echo "[plan] No se pudo instalar Flatpak org.DolphinEmu.dolphin-emu" >&2
  flatpak install -y flathub "org.alienarena.alienarena" || echo "[plan] No se pudo instalar Flatpak org.alienarena.alienarena" >&2
  flatpak install -y flathub "org.audacityteam.Audacity" || echo "[plan] No se pudo instalar Flatpak org.audacityteam.Audacity" >&2
  flatpak install -y flathub "org.fedoraproject.MediaWriter" || echo "[plan] No se pudo instalar Flatpak org.fedoraproject.MediaWriter" >&2
  flatpak install -y flathub "org.freeciv.qt" || echo "[plan] No se pudo instalar Flatpak org.freeciv.qt" >&2
  flatpak install -y flathub "org.gnome.Epiphany" || echo "[plan] No se pudo instalar Flatpak org.gnome.Epiphany" >&2
  flatpak install -y flathub "org.gnome.NetworkDisplays" || echo "[plan] No se pudo instalar Flatpak org.gnome.NetworkDisplays" >&2
  flatpak install -y flathub "org.gnome.Snapshot" || echo "[plan] No se pudo instalar Flatpak org.gnome.Snapshot" >&2
  flatpak install -y flathub "org.gnome.Weather" || echo "[plan] No se pudo instalar Flatpak org.gnome.Weather" >&2
  flatpak install -y flathub "org.jdownloader.JDownloader" || echo "[plan] No se pudo instalar Flatpak org.jdownloader.JDownloader" >&2
  flatpak install -y flathub "org.kde.kclock" || echo "[plan] No se pudo instalar Flatpak org.kde.kclock" >&2
  flatpak install -y flathub "org.kde.kdenlive" || echo "[plan] No se pudo instalar Flatpak org.kde.kdenlive" >&2
  flatpak install -y flathub "org.kde.ktorrent" || echo "[plan] No se pudo instalar Flatpak org.kde.ktorrent" >&2
  flatpak install -y flathub "org.kde.okular" || echo "[plan] No se pudo instalar Flatpak org.kde.okular" >&2
  flatpak install -y flathub "org.libretro.RetroArch" || echo "[plan] No se pudo instalar Flatpak org.libretro.RetroArch" >&2
  flatpak install -y flathub "org.nickvision.tubeconverter" || echo "[plan] No se pudo instalar Flatpak org.nickvision.tubeconverter" >&2
  flatpak install -y flathub "org.openshot.OpenShot" || echo "[plan] No se pudo instalar Flatpak org.openshot.OpenShot" >&2
  flatpak install -y flathub "org.ppsspp.PPSSPP" || echo "[plan] No se pudo instalar Flatpak org.ppsspp.PPSSPP" >&2
  flatpak install -y flathub "org.shotcut.Shotcut" || echo "[plan] No se pudo instalar Flatpak org.shotcut.Shotcut" >&2
  flatpak install -y flathub "org.upscayl.Upscayl" || echo "[plan] No se pudo instalar Flatpak org.upscayl.Upscayl" >&2
  flatpak install -y flathub "org.xonotic.Xonotic" || echo "[plan] No se pudo instalar Flatpak org.xonotic.Xonotic" >&2
  flatpak install -y flathub "org.yamagi.YamagiQ2" || echo "[plan] No se pudo instalar Flatpak org.yamagi.YamagiQ2" >&2
  flatpak install -y flathub "rs.ruffle.Ruffle" || echo "[plan] No se pudo instalar Flatpak rs.ruffle.Ruffle" >&2
  flatpak install -y flathub "su.xash.Engine.Compat.i386" || echo "[plan] No se pudo instalar Flatpak su.xash.Engine.Compat.i386" >&2
  flatpak install -y flathub "tv.kodi.Kodi" || echo "[plan] No se pudo instalar Flatpak tv.kodi.Kodi" >&2
else
  echo "[plan] Flatpak no disponible; se omiten 54 apps." >&2
fi

echo "[plan] Finalizado."
