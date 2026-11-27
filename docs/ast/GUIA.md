# Guía didáctica — autoapp-mirror (bable / asturianu)

Esta guía enseña, pasu a pasu y ensin suponer conocimientos previos, a usar
`autoapp-mirror` pa inventariar les aplicaciones del to Linux y llevales a otra
distribución.

## 0. Antes d'empezar

Precises:

- Un equipu Linux (da igual GNOME, KDE, XFCE, i3, Wayland…).
- Bash 4+ (`bash --version`).
- Permisos de sudo **namás si** vas instalar paquetes.
- Opcionalmente `flatpak`, `snap`, `lsblk` y `df` pa un inventariu más completu.

Comprueba'l sistema:

```bash
cat /etc/os-release
echo "$XDG_CURRENT_DESKTOP"
```

> L'escritoriu detéctase pero **non camuda nada**: el script solo fala col
> xestor de paquetes y col discu.

## 1. Xenerar l'inventariu (seguru, nun instala nada)

```bash
cd autoapp-mirror
./scripts/autoapp.sh --out ./inventory
```

Verás tres bloques:

1. **Informe del discu**: `lsblk` (discos y particiones) y `df -h` (espaciu llibre).
2. **Inventariu**: cuántos paquetes nativos, Flatpaks, snaps y scripts hai.
3. **Planes**: un `.sh` por distro.

Mira los resultaos:

```bash
cat inventory/reporte.txt
python3 -m json.tool inventory/inventory.json | less
ls -l inventory/plan-*.sh
```

## 2. Entender l'informe del discu

El script calcula los GiB llibres de la partición onde ta'l direutoriu de salida:

```
Espacio libre       : 292.71 GiB
Espacio suficiente para el plan completo (recomendado >= 40 GiB).
```

Si apaez `Espacio libre insuficiente`, nun pasa nada: los planes xenérense igual,
pero avísate de que quiciabes nun quepan SDKs, contenedores o xuegos.
Pues escoller otru discu con `--out /mnt/otru-discu/inventory`.

Namás el discu:

```bash
./scripts/autoapp.sh --check-disk
```

## 3. Lleer un plan

```bash
sed -n '1,60p' inventory/plan-debian.sh
```

Verás daqué asina:

```bash
PKGS=(
  "7zip"
  "abiword"
  "android-tools"
  ...
)
apt-get update
apt-get install -y --no-install-recommends "${PKGS[@]}"
```

Al final apaez la seición:

```
[plan] NO PORTABLE / REVISION MANUAL (400):
# - aspnetcore-runtime-dbg-10.0 (sin equivalente portable)
# - ...
```

**Esa seición ye la más importante.** Dizte lo que nun se pue traducir:
snaps, AppImages, paquetes de repos privados (AnyDesk, Discord, Chrome…),
controladores NVIDIA o metapaquetes de Debian.

## 4. Aplicar el plan n'otra distro

Copia'l plan correspondiente a la máquina de destino:

```bash
scp inventory/plan-fedora.sh usuario@otra-maquina:~/
```

Na máquina de destino (Fedora, nel exemplu):

```bash
sudo bash plan-fedora.sh
```

El plan **nun s'executa solo**: ta fechu pa que lo revises primero.

Si quieres que la mesma ferramienta lo aplique na distro onde tas:

```bash
sudo ./scripts/autoapp.sh --apply --yes
```

Ensin `--yes` pidirákhe confirmación.

## 5. El plan Flatpak (la ponte universal)

Flatpak funciona igual en cuasi cualquier distro. Por eso'l script escribe
`plan-flatpak.sh` colos **54 IDs reales** inventariaos nel equipu d'orixe:

```bash
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub "org.kde.kdenlive"
flatpak install -y flathub "tv.kodi.Kodi"
...
```

Ye la opción más fiable cuando'l destino ye una distro mui distinta
(p. ex. pasar d'Ubuntu a Alpine).

## 6. Personalizar el mapa

Edita `data/package-map.tsv`. Cada fila:

```
clave	apt	dnf	pacman	apk	zypper	flatpak	notas
```

Exemplu real del archivu:

```
build-essential	build-essential	gcc gcc-c++ make	base-devel	build-base gcc musl-dev	patterns-devel-base-devel_basis	-	Metapaquete; equivalente por distro.
```

Mira que Fedora usa **tres** paquetes (`gcc gcc-c++ make`) separaos por espacios.
El script espándelos correutamente.

Pa amestar una app Flatpak nueva:

```
fp:org.lacompanyia.LaMioApp	-	-	-	-	-	org.lacompanyia.LaMioApp	App propia.
```

Xenera de nuevo con `--map`.

## 7. Fallos frecuentes

| Síntoma | Causa | Solución |
|---|---|---|
| `Nun se reconoció nengún xestor` | distro minimalista | Instala `apt`, `dnf`, `pacman`… o usa'l plan Flatpak |
| `Nun s'atopó mapa` | ruta equivocada | Pasa `--map data/package-map.tsv` |
| Munchos `NO PORTABLE` | ye normal | Revisa la seición y decide a mano |
| `flatpak install` falla | ensin flathub | El plan ya añade'l remotu; comprueba la rede |
| `Espaciu insuficiente` | partición pequeña | Camuda `--out` a otru discu |

## 8. Resumu pa recordar

1. `./scripts/autoapp.sh --out ./inventory` → **inventariu + planes** (seguru).
2. `cat inventory/reporte.txt` → **qué hai y qué nun ye portable**.
3. `sudo bash inventory/plan-<distro>.sh` → **instalar nel destino**.
4. `--apply --yes` → aplicar na máquina actual.
5. L'escritoriu **non importa**; el mapa y Flatpak son la clave.
