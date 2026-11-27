# Guía didáctica — autoapp-mirror (español)

Esta guía te enseña, paso a paso y sin suponer conocimientos previos, a usar
`autoapp-mirror` para inventariar las aplicaciones de tu Linux y llevarlas a
otra distro.

## 0. Antes de empezar

Necesitas:

- Un equipo Linux (da igual GNOME, KDE, XFCE, i3, Wayland…).
- Bash 4+ (`bash --version`).
- Permisos de sudo **solo si** vas a instalar paquetes.
- Opcionalmente `flatpak`, `snap`, `lsblk` y `df` para un inventario más completo.

Comprueba tu sistema:

```bash
cat /etc/os-release
echo "$XDG_CURRENT_DESKTOP"
```

> El escritorio se detecta pero **no cambia nada**: el script solo habla con el
> gestor de paquetes y con el disco.

## 1. Generar el inventario (seguro, no instala nada)

```bash
cd autoapp-mirror
./scripts/autoapp.sh --out ./inventory
```

Verás en pantalla tres bloques:

1. **Informe de disco**: `lsblk` (discos y particiones) y `df -h` (espacio libre).
2. **Inventario**: cuántos paquetes nativos, Flatpaks, snaps y scripts hay.
3. **Planes**: un `.sh` por distro.

Abre los resultados:

```bash
cat inventory/reporte.txt
python3 -m json.tool inventory/inventory.json | less
ls -l inventory/plan-*.sh
```

## 2. Entender el informe de disco

El script calcula los GiB libres de la partición donde esté el directorio de salida:

```
Espacio libre       : 292.71 GiB
Espacio suficiente para el plan completo (recomendado >= 40 GiB).
```

Si aparece `Espacio libre insuficiente`, no pasa nada: el script sigue generando
los planes pero te avisa de que quizá no quepan SDKs, contenedores o juegos.
Puedes elegir otro disco con `--out /mnt/otro-disco/inventario`.

Para ver solo el disco:

```bash
./scripts/autoapp.sh --check-disk
```

## 3. Leer un plan

```bash
sed -n '1,60p' inventory/plan-debian.sh
```

Verás algo así:

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

Al final aparece la sección:

```
[plan] NO PORTABLE / REVISION MANUAL (400):
# - aspnetcore-runtime-dbg-10.0 (sin equivalente portable)
# - ...
```

**Esa sección es la más importante.** Te dice qué no se puede traducir:
snaps, AppImages, paquetes de repos privados (AnyDesk, Discord, Chrome…),
controladores NVIDIA o metapaquetes de Debian.

## 4. Aplicar el plan en otra distro

Copia el plan correspondiente a la máquina de destino:

```bash
scp inventory/plan-fedora.sh usuario@otra-maquina:~/
```

En la máquina de destino (Fedora, en el ejemplo):

```bash
sudo bash plan-fedora.sh
```

El plan **no se ejecuta solo**: está diseñado para que lo revises primero.

Si quieres que la propia herramienta lo aplique en la distro donde estás:

```bash
sudo ./scripts/autoapp.sh --apply --yes
```

Sin `--yes` te pedirá confirmación.

## 5. El plan Flatpak (el puente universal)

Flatpak funciona igual en casi cualquier distro. Por eso el script genera
`plan-flatpak.sh` con los **54 IDs reales** inventariados en el equipo de origen:

```bash
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub "org.kde.kdenlive"
flatpak install -y flathub "tv.kodi.Kodi"
...
```

Es la opción más fiable cuando el destino es una distro muy diferente
(por ejemplo, pasar de Ubuntu a Alpine).

## 6. Personalizar el mapa

Edita `data/package-map.tsv`. Cada fila:

```
clave	apt	dnf	pacman	apk	zypper	flatpak	notas
```

Ejemplo real del archivo:

```
build-essential	build-essential	gcc gcc-c++ make	base-devel	build-base gcc musl-dev	patterns-devel-base-devel_basis	-	Metapaquete; equivalente por distro.
```

Fíjate en que Fedora usa **tres** paquetes (`gcc gcc-c++ make`) separados por
espacios. El script los expande correctamente.

Si añades una app Flatpak nueva:

```
fp:org.miempresa.MiApp	-	-	-	-	-	org.miempresa.MiApp	App propia.
```

Vuelve a generar con `--map`.

## 7. Errores frecuentes

| Síntoma | Causa | Solución |
|---|---|---|
| `No se reconoció ningún gestor` | distro minimalista | Instala `apt`, `dnf`, `pacman`… o usa el plan Flatpak |
| `No se encontró mapa` | ruta equivocada | Pasa `--map data/package-map.tsv` |
| Muchos `NO PORTABLE` | es normal | Revisa la sección y decide manualmente |
| `flatpak install` falla |.sin flathub | El plan ya añade el remoto; comprueba red |
| `Espacio insuficiente` | partición pequeña | Cambia `--out` a otro disco |

## 8. Resumen para recordar

1. `./scripts/autoapp.sh --out ./inventory` → **inventario + planes** (seguro).
2. `cat inventory/reporte.txt` → **qué hay y qué no es portable**.
3. `sudo bash inventory/plan-<distro>.sh` → **instalar en destino**.
4. `--apply --yes` → aplicar en la máquina actual.
5. El escritorio **no importa**; el mapa y Flatpak son la clave.
