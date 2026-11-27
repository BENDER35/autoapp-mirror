# autoapp-mirror

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**Inventario y reinstalación portable de aplicaciones Linux, sin depender del entorno de escritorio.**

**Repositorios:** [GitHub](https://github.com/BENDER35/autoapp-mirror) · [GitLab (mirror)](https://gitlab.com/BENDER_5000/autoapp-mirror)

`autoapp-mirror` inspecciona un equipo Linux, descubre qué aplicaciones tiene instaladas
(paquetes nativos, Flatpak, Snap y scripts de usuario), mide el espacio real de las
particiones y genera **planes de instalación reproducibles para varias distros**
(Debian/Ubuntu, Fedora/RHEL, Arch, Alpine, openSUSE, más un plan solo-Flatpak).

> **Aviso importante:** no existe un mapa 1:1 de paquetes entre distros. Este proyecto
> es honesto al respecto: traduce lo que se puede, usa Flatpak como puente cuando es
> posible y **marca explícitamente lo que no es portable** para revisión manual.
> Nunca instala nada sin que tú lo confirmes.

---

## Idiomas / Languages / Llingües

- [Español → guía didáctica](docs/es/GUIA.md)
- [English → guide](docs/en/GUIDE.md)
- [Bable (asturianu) → guía](docs/ast/GUIA.md)

---

## Qué hace exactamente

1. **Detecta** `ID`, `ID_LIKE`, versión, gestor de paquetes (`apt`, `dnf`, `pacman`,
   `apk`, `zypper`, `xbps`) y escritorio (`XDG_CURRENT_DESKTOP`). El escritorio es
   **solo informativo**: no influye en la instalación.
2. **Inventaría**:
   - paquetes instalados manualmente/nativos (`apt-mark showmanual`, `rpm -qa`, `pacman -Qqe`, …),
   - aplicaciones Flatpak (`flatpak list --app`),
   - snaps (`snap list`),
   - scripts ejecutables en `~/.local/bin`.
3. **Analiza el disco** con `lsblk` y `df`/`findmnt`, calcula los GiB libres de la
   partición de salida y avisa si hay menos de 40 GiB (umbral conservador para un
   plan completo con SDKs, contenedores y juegos).
4. **Escribe** en el directorio de salida:
   - `inventory.json` — inventario estructurado,
   - `reporte.txt` — resumen legible,
   - `plan-debian.sh`, `plan-fedora.sh`, `plan-arch.sh`, `plan-alpine.sh`,
     `plan-suse.sh`, `plan-flatpak.sh` — planes ejecutables **pero no ejecutados**.
5. **Opcionalmente aplica** el plan de la distro actual con `--apply --yes`.

---

## Uso rápido

```bash
# 1. Generar inventario y planes (NO instala nada)
./scripts/autoapp.sh --out ./inventory

# 2. Ver solo el informe de disco
./scripts/autoapp.sh --check-disk

# 3. Aplicar en LA distro actual (¡instala paquetes!)
sudo ./scripts/autoapp.sh --out ./inventory --apply --yes

# 4. Usar otro mapa de traducción
./scripts/autoapp.sh --map data/package-map.tsv --out /tmp/mi-inventario
```

### Opciones

| Opción | Descripción |
|---|---|
| `-h, --help` | Ayuda |
| `-V, --version` | Versión |
| `-o, --out DIR` | Directorio de salida |
| `-m, --map FILE` | Mapa TSV de traducción |
| `-a, --apply` | Aplica el plan en esta distro |
| `-y, --yes` | Sin confirmación con `--apply` |
| `-v, --verbose` | Más detalle |
| `--check-disk` | Solo informe de disco |

---

## Formato del mapa (`data/package-map.tsv`)

Ocho columnas separadas por tabulador:

```
clave	apt	dnf	pacman	apk	zypper	flatpak	notas
```

- `clave`: identificador canónico del paquete de origen.
- Columnas de distro: nombre del paquete equivalente; varios paquetes se separan
  con un espacio; `-` o vacío = sin equivalente.
- `flatpak`: ID de Flathub cuando existe alternativa sandbox.
- `notas`: motivo de no portabilidad o aclaración.

Las filas `fp:<ID>` representan apps Flatpak reales inventariadas en el equipo de
origen y se usan para construir `plan-flatpak.sh`.

---

## Esqueleto del repositorio

```
autoapp-mirror/
├── scripts/autoapp.sh          # Herramienta principal
├── data/package-map.tsv        # Mapa de traducción
├── docs/
│   ├── es/GUIA.md              # Guía en español
│   ├── en/GUIDE.md             # Guía en inglés
│   └── ast/GUIA.md             # Guía en bable (asturianu)
├── .github/workflows/
│   ├── mirror.yml              # GitHub → GitLab
│   └── release.yml             # Release con ZIP
├── .gitlab-ci.yml              # GitLab → GitHub (espejo inverso)
├── mirroring/sync-bidirectional.sh
├── inventory/                  # Generado por el script (ejemplo)
└── dist/                       # ZIP de release
```

---

## Espejo (mirror) GitHub ⇄ GitLab

El repositorio incluye sincronización bidireccional:

- **GitHub → GitLab**: `.github/workflows/mirror.yml` (push a `main`).
- **GitLab → GitHub**: `.gitlab-ci.yml` (push a `main`).
- **Manual**: `mirroring/sync-bidirectional.sh`.

### Configuración necesaria

| Secreto / Variable | Dónde | Uso |
|---|---|---|
| `GITLAB_TOKEN` | Secrets de GitHub | Push a GitLab desde Actions |
| `GITLAB_URL` | Secrets de GitHub | `gitlab.com` o instancia self-hosted |
| `GITLAB_GROUP` | Secrets de GitHub | Grupo/namespace destino |
| `GH_TOKEN` | CI/CD variables de GitLab | Push a GitHub desde GitLab CI |
| `GITHUB_USER` | CI/CD variables de GitLab | Usuario de GitHub |

Para verificar el espejo después de configurar los secretos:

```bash
./mirroring/verify-mirror.sh https://github.com/<usuario>/autoapp-mirror.git \
  https://gitlab.com/<grupo>/autoapp-mirror.git
```

---

## Release

```bash
./scripts/build-release.sh 1.0.0
```

Genera `dist/autoapp-mirror-1.0.0.zip` con el script, mapa, documentación,
workflows y un `inventory/` de ejemplo. El workflow `release.yml` crea una
GitHub Release al hacer `git tag v1.0.0 && git push --tags`.

---

## Licencia

MIT. Consulta [LICENSE](LICENSE).
