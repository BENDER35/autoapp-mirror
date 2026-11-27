# Tutorial — autoapp-mirror (English)

This guide walks you through `autoapp-mirror` step by step, assuming no prior
knowledge, to inventory the applications on your Linux box and move them to
another distribution.

## 0. Before you start

You need:

- Any Linux machine (GNOME, KDE, XFCE, i3, Wayland… it does not matter).
- Bash 4+ (`bash --version`).
- `sudo` **only if** you actually install packages.
- Optionally `flatpak`, `snap`, `lsblk` and `df` for a fuller inventory.

Check your system:

```bash
cat /etc/os-release
echo "$XDG_CURRENT_DESKTOP"
```

> The desktop environment is detected but **changes nothing**: the script only
> talks to the package manager and the disk.

## 1. Generate the inventory (safe, installs nothing)

```bash
cd autoapp-mirror
./scripts/autoapp.sh --out ./inventory
```

You will see three blocks:

1. **Disk report**: `lsblk` (disks/partitions) and `df -h` (free space).
2. **Inventory**: how many native packages, Flatpaks, snaps and user scripts.
3. **Plans**: one `.sh` per distribution.

Inspect the results:

```bash
cat inventory/reporte.txt
python3 -m json.tool inventory/inventory.json | less
ls -l inventory/plan-*.sh
```

## 2. Understanding the disk report

The script computes the free GiB on the partition holding the output directory:

```
Espacio libre       : 292.71 GiB
Espacio suficiente para el plan completo (recomendado >= 40 GiB).
```

If you see `Espacio libre insuficiente`, nothing breaks: plans are still
generated, but you are warned that SDKs, containers or games may not fit.
Pick another disk with `--out /mnt/other-disk/inventory`.

Disk only:

```bash
./scripts/autoapp.sh --check-disk
```

## 3. Reading a plan

```bash
sed -n '1,60p' inventory/plan-debian.sh
```

Example:

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

At the end you will find:

```
[plan] NO PORTABLE / MANUAL REVIEW (400):
# - aspnetcore-runtime-dbg-10.0 (sin equivalente portable)
# - ...
```

**This section is the most important one.** It lists what cannot be translated:
snaps, AppImages, private-repo packages (AnyDesk, Discord, Chrome…), NVIDIA
drivers or Debian metapackages.

## 4. Applying a plan on another distro

Copy the matching plan to the target machine:

```bash
scp inventory/plan-fedora.sh user@other-host:~/
```

On the target (Fedora in this example):

```bash
sudo bash plan-fedora.sh
```

Plans are **never run automatically**: they are meant to be reviewed first.

To let the tool apply the plan on the current distro:

```bash
sudo ./scripts/autoapp.sh --apply --yes
```

Without `--yes` you will be prompted for confirmation.

## 5. The Flatpak plan (the universal bridge)

Flatpak behaves the same on nearly every distro. That is why the script writes
`plan-flatpak.sh` with the **54 real IDs** inventoried on the source machine:

```bash
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub "org.kde.kdenlive"
flatpak install -y flathub "tv.kodi.Kodi"
...
```

This is the most reliable route when the target is very different
(e.g. moving from Ubuntu to Alpine).

## 6. Customising the map

Edit `data/package-map.tsv`. Each row:

```
key	apt	dnf	pacman	apk	zypper	flatpak	notes
```

Real example from the file:

```
build-essential	build-essential	gcc gcc-c++ make	base-devel	build-base gcc musl-dev	patterns-devel-base-devel_basis	-	Metapaquete; equivalente por distro.
```

Note Fedora uses **three** packages (`gcc gcc-c++ make`) separated by spaces.
The script expands them correctly.

To add a new Flatpak app:

```
fp:org.mycompany.MyApp	-	-	-	-	-	org.mycompany.MyApp	In-house app.
```

Regenerate with `--map`.

## 7. Common issues

| Symptom | Cause | Fix |
|---|---|---|
| `No package manager recognised` | minimal distro | Install `apt`, `dnf`, `pacman`… or use the Flatpak plan |
| `No map found` | wrong path | Pass `--map data/package-map.tsv` |
| Many `NO PORTABLE` entries | expected | Review the section and decide manually |
| `flatpak install` fails | no flathub | The plan adds the remote; check networking |
| `Insufficient space` | small partition | Change `--out` to another disk |

## 8. Cheat sheet

1. `./scripts/autoapp.sh --out ./inventory` → **inventory + plans** (safe).
2. `cat inventory/reporte.txt` → **what exists and what is not portable**.
3. `sudo bash inventory/plan-<distro>.sh` → **install on the target**.
4. `--apply --yes` → apply on the current machine.
5. The desktop **does not matter**; the map and Flatpak are the key.
