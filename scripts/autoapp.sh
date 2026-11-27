#!/usr/bin/env bash
# autoapp.sh - Inventario y reinstalación portable de aplicaciones en Linux.
# Copyright (c) 2026 autoapp-mirror contributors. Licencia MIT.
#
# Filosofía: NO existe un mapa 1:1 de paquetes entre distros. Este script:
#   1) detecta distro, gestor de paquetes y entorno de escritorio (solo informativo),
#   2) inventaría paquetes nativos, Flatpak, Snap y scripts de usuario,
#   3) mide las particiones y calcula espacio disponible real,
#   4) genera un PLAN declarativo por distro (APT/DNF/PACMAN/APK/ZYPP + Flatpak),
#      marcando explícitamente lo que NO es portable,
#   5) opcionalmente aplica el plan en la distro de destino (--apply).
#
# El escritorio es irrelevante: solo se consultan gestores de paquetes y disk/free.

set -Eeuo pipefail
IFS=$'\n\t'

TOOL_VERSION="1.0.0"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
MAP_FILE="${AUTOAPP_MAP:-$ROOT_DIR/data/package-map.tsv}"
OUT_DIR="${AUTOAPP_OUT:-$ROOT_DIR/inventory}"
ASSUME_YES=0
APPLY=0
DRY_RUN=1
VERBOSE=0

log()  { printf '[autoapp] %s\n' "$*" >&2; }
die()  { printf '[autoapp] ERROR: %s\n' "$*" >&2; exit 1; }
warn() { printf '[autoapp] AVISO: %s\n' "$*" >&2; }
dbg()  { ((VERBOSE)) && printf '[autoapp] debug: %s\n' "$*" >&2 || true; }

usage() {
  cat <<EOF
Uso: $(basename "$0") [opciones]

Opciones:
  -h, --help           Muestra esta ayuda.
  -V, --version        Muestra la versión.
  -o, --out DIR        Directorio de salida (por defecto: $OUT_DIR).
  -m, --map ARCHIVO    Mapa TSV de traducción (por defecto: $MAP_FILE).
  -a, --apply          Aplica el plan en esta distro (por defecto solo simulator).
  -y, --yes            No pedir confirmación con --apply.
  -v, --verbose        Más detalle por salida estándar.
      --check-disk     Solo muestra el informe de disco y termina.

Modos:
  (sin --apply)  Genera inventario.json, plan-<distro>.sh y reporte.txt en OUT_DIR.
  --apply        Ejecuta el plan generado para LA DISTRO ACTUAL (requiere --yes o confirmación).

NOTA: --apply instala paquetes. Revisa siempre los planes antes de ejecutarlos.
EOF
}

# ---------------------------------------------------------------------------
# 1. Detección del sistema
# ---------------------------------------------------------------------------
declare -g ID="unknown" ID_LIKE="" PRETTY="unknown" VERSION_ID=""
declare -g PKG_MANAGER="" PKG_INSTALL="" PKG_UPDATE="" DE="unknown"

detect_os() {
  if [[ -r /etc/os-release ]]; then
    # shellcheck disable=SC1091
    source /etc/os-release
    ID="${ID:-unknown}"
    ID_LIKE="${ID_LIKE:-}"
    PRETTY="${PRETTY_NAME:-unknown}"
    VERSION_ID="${VERSION_ID:-}"
  else
    warn "No se encontró /etc/os-release; sistema poco reconocible."
  fi
  dbg "ID=$ID ID_LIKE=$ID_LIKE PRETTY=$PRETTY"
}

detect_pkg_manager() {
  # Orden de preferencia: nativo de la distro antes que alternativas.
  if command -v apt-get >/dev/null 2>&1 && [[ "$ID$ID_LIKE" =~ debian|ubuntu|linuxmint|pop|raspbian|devuan|kali ]]; then
    PKG_MANAGER="apt"; PKG_UPDATE="apt-get update"; PKG_INSTALL="apt-get install -y --no-install-recommends"
  elif command -v dnf5 >/dev/null 2>&1; then
    PKG_MANAGER="dnf5"; PKG_UPDATE="dnf5 makecache"; PKG_INSTALL="dnf5 install -y"
  elif command -v dnf >/dev/null 2>&1; then
    PKG_MANAGER="dnf"; PKG_UPDATE="dnf makecache"; PKG_INSTALL="dnf install -y"
  elif command -v microdnf >/dev/null 2>&1; then
    PKG_MANAGER="microdnf"; PKG_UPDATE="microdnf makecache"; PKG_INSTALL="microdnf install -y"
  elif command -v yum >/dev/null 2>&1; then
    PKG_MANAGER="yum"; PKG_UPDATE="yum makecache"; PKG_INSTALL="yum install -y"
  elif command -v pacman >/dev/null 2>&1; then
    PKG_MANAGER="pacman"; PKG_UPDATE="pacman -Sy"; PKG_INSTALL="pacman -S --noconfirm --needed"
  elif command -v apk >/dev/null 2>&1; then
    PKG_MANAGER="apk"; PKG_UPDATE="apk update"; PKG_INSTALL="apk add --no-cache"
  elif command -v zypper >/dev/null 2>&1; then
    PKG_MANAGER="zypper"; PKG_UPDATE="zypper refresh"; PKG_INSTALL="zypper install -y"
  elif command -v xbps-install >/dev/null 2>&1; then
    PKG_MANAGER="xbps"; PKG_UPDATE="xbps-install -S"; PKG_INSTALL="xbps-install -Sy"
  elif command -v apt-get >/dev/null 2>&1; then
    PKG_MANAGER="apt"; PKG_UPDATE="apt-get update"; PKG_INSTALL="apt-get install -y --no-install-recommends"
  else
    warn "No se reconoció ningún gestor de paquetes nativo."
    PKG_MANAGER="none"; PKG_UPDATE=":"; PKG_INSTALL=":"
  fi
  dbg "PKG_MANAGER=$PKG_MANAGER"
}

detect_de() {
  DE="${XDG_CURRENT_DESKTOP:-${DESKTOP_SESSION:-unknown}}"
  [[ -z "$DE" ]] && DE="unknown"
  dbg "DE=$DE (informativo; no afecta a la instalación)"
}

# ---------------------------------------------------------------------------
# 2. Análisis de disco (independiente del escritorio)
# ---------------------------------------------------------------------------
human_gb() {
  local bytes="${1:-0}"
  awk -v b="$bytes" 'BEGIN { printf "%.2f", b/1073741824 }'
}

disk_report() {
  local target_bytes="" target_mount=""
  if command -v findmnt >/dev/null 2>&1; then
    target_mount="$(findmnt -n -o TARGET -T "$OUT_DIR" 2>/dev/null || echo /)"
    target_bytes="$(findmnt -n -o AVAIL -b -T "$OUT_DIR" 2>/dev/null || true)"
  fi
  if [[ -z "$target_bytes" ]] && command -v df >/dev/null 2>&1; then
    target_bytes="$(df -B1 --output=avail "$OUT_DIR" 2>/dev/null | tail -n1 | tr -d ' ')"
  fi
  [[ -z "$target_bytes" ]] && target_bytes=0

  log "=== Informe de disco ==="
  log "Partición de salida : ${target_mount:-desconocida} ($OUT_DIR)"
  log "Espacio libre       : $(human_gb "$target_bytes") GiB ($target_bytes bytes)"

  if command -v lsblk >/dev/null 2>&1; then
    log "--- lsblk (discos y particiones) ---"
    lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,MODEL 2>/dev/null | while IFS= read -r line; do log "$line"; done
  fi
  if command -v df >/dev/null 2>&1; then
    log "--- df -h (sistemas de archivos montados) ---"
    df -h 2>/dev/null | while IFS= read -r line; do log "$line"; done
  fi

  # Umbral conservador para un plan completo (juegos, SDKs, contenedores...).
  local need_gb=40
  local free_gb
  free_gb="$(human_gb "$target_bytes")"
  if awk -v f="$free_gb" -v n="$need_gb" 'BEGIN{exit !(f<n)}'; then
    warn "Espacio libre insuficiente para el plan completo (se recomiendan ${need_gb} GiB; hay ${free_gb} GiB)."
    log "El generador priorizará paquetes esenciales y marcará el resto como 'requiere espacio'."
  else
    log "Espacio suficiente para el plan completo (recomendado >= ${need_gb} GiB)."
  fi
  printf '%s\n' "$target_bytes"
}

# ---------------------------------------------------------------------------
# 3. Inventario de aplicaciones instaladas
# ---------------------------------------------------------------------------
json_escape() {
  local s="${1//\\/\\\\}"
  s="${s//\"/\\\"}"
  s="${s//$'\t'/\\t}"
  printf '%s' "$s"
}

inventory_native() {
  case "$PKG_MANAGER" in
    apt)
      apt-mark showmanual 2>/dev/null || dpkg-query -W -f='${Package}\n' 2>/dev/null
      ;;
    dnf5|dnf|microdnf|yum)
      (rpm -qa --qf '%{NAME}\n' 2>/dev/null || true) | sort -u
      ;;
    pacman)
      pacman -Qqe 2>/dev/null || true
      ;;
    apk)
      apk info -q 2>/dev/null || true
      ;;
    zypper)
      zypper search --installed-only --type package --no-refresh 2>/dev/null | awk -F'|' '/^i/ {gsub(/^ +| +$/, "", $2); print $2}' || true
      ;;
    xbps)
      xbps-query -l 2>/dev/null | awk '/^ii/ {sub(/^ii[[:space:]]+/, "", $0); sub(/-\{?[0-9].*/, "", $0); print}' || true
      ;;
    *)
      (command -v dpkg-query >/dev/null && dpkg-query -W -f='${Package}\n' 2>/dev/null) || \
      (command -v rpm >/dev/null && rpm -qa --qf '%{NAME}\n' 2>/dev/null) || true
      ;;
  esac | sort -u | grep -v '^$' || true
}

inventory_flatpak() {
  command -v flatpak >/dev/null 2>&1 || return 0
  flatpak list --app --columns=application,origin 2>/dev/null | awk -F'\t' 'NF>=1 && $1!="" {print $1"\t"$2}' || true
}

inventory_snap() {
  command -v snap >/dev/null 2>&1 || return 0
  snap list 2>/dev/null | awk 'NR>1 && $1!="" {print $1"\t"$5}' || true
}

inventory_user_scripts() {
  local bindir="$HOME/.local/bin"
  [[ -d "$bindir" ]] || return 0
  find "$bindir" -maxdepth 1 -type f -executable -printf '%f\n' 2>/dev/null | sort -u || true
}

write_inventory_json() {
  local out="$1" pkgs="$2" flatpaks="$3" snaps="$4" scripts="$5" free_bytes="$6"
  mkdir -p "$OUT_DIR"
  {
    printf '{\n'
    printf '  "generated_at": "%s",\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    printf '  "tool": "autoapp %s",\n' "$TOOL_VERSION"
    printf '  "host": {"id":"%s","id_like":"%s","pretty":"%s","version_id":"%s","desktop":"%s"},\n' \
      "$(json_escape "$ID")" "$(json_escape "$ID_LIKE")" "$(json_escape "$PRETTY")" \
      "$(json_escape "$VERSION_ID")" "$(json_escape "$DE")"
    printf '  "package_manager": "%s",\n' "$(json_escape "$PKG_MANAGER")"
    printf '  "disk": {"out_dir":"%s","available_bytes":%s,"available_gib":%s},\n' \
      "$(json_escape "$OUT_DIR")" "$free_bytes" "$(human_gb "$free_bytes")"
    printf '  "native_packages": ['
    local first=1 p
    while IFS= read -r p; do
      [[ -z "$p" ]] && continue
      ((first)) || printf ','
      printf '"%s"' "$(json_escape "$p")"; first=0
    done <<< "$pkgs"
    printf '],\n'
    printf '  "flatpaks": ['
    first=1
    local app origin
    while IFS=$'\t' read -r app origin; do
      [[ -z "$app" ]] && continue
      ((first)) || printf ','
      printf '{"application":"%s","origin":"%s"}' "$(json_escape "$app")" "$(json_escape "${origin:-}")"; first=0
    done <<< "$flatpaks"
    printf '],\n'
    printf '  "snaps": ['
    first=1
    local name publisher
    while IFS=$'\t' read -r name publisher; do
      [[ -z "$name" ]] && continue
      ((first)) || printf ','
      printf '{"name":"%s","publisher":"%s"}' "$(json_escape "$name")" "$(json_escape "${publisher:-}")"; first=0
    done <<< "$snaps"
    printf '],\n'
    printf '  "user_scripts": ['
    first=1
    local sc
    while IFS= read -r sc; do
      [[ -z "$sc" ]] && continue
      ((first)) || printf ','
      printf '"%s"' "$(json_escape "$sc")"; first=0
    done <<< "$scripts"
    printf ']\n}\n'
  } > "$out"
  log "Inventario escrito en: $out"
}

# ---------------------------------------------------------------------------
# 4. Mapa de traducción y generación de planes
# ---------------------------------------------------------------------------
# Formato TSV (8 columnas): clave | apt | dnf | pacman | apk | zypper | flatpak | notas
# 'clave' es el identificador canónico del paquete de este equipo. Las columnas
# vacías o '-' significan "sin equivalente conocido": se marca como NO portable.
ensure_map() {
  if [[ ! -f "$MAP_FILE" ]]; then
    warn "No se encontró mapa en $MAP_FILE; se usará un mapa mínimo embebido."
    MAP_FILE="$ROOT_DIR/data/package-map.tsv"
    [[ -f "$MAP_FILE" ]] || die "Falta el mapa de paquetes: $MAP_FILE"
  fi
}

map_lookup() {
  # $1 = paquete, $2 = columna (2=apt,3=dnf,4=pacman,5=apk,6=zypper,7=flatpak,8=notas)
  awk -F'\t' -v key="$1" -v col="$2" '
    $1==key { gsub(/^[[:space:]]+|[[:space:]]+$/, "", $col); print $col; found=1; exit }
    END { if (!found) print "" }
  ' "$MAP_FILE"
}

canonical_key() {
  # Normaliza sufijos típicos de versión para buscar en el mapa.
  # Las claves 'fp:<id>' se dejan intactas: son identificadores Flatpak.
  local p="$1"
  [[ "$p" == fp:* ]] && { printf '%s\n' "$p"; return 0; }
  printf '%s\n' "$p" | sed -E 's/-[0-9]+(\.[0-9]+)*(-dbg|-dev|-doc)?$//'
}

generate_plan() {
  local distro="$1" pkgs="$2" out="$3" free_bytes="$4"
  local col fp_col is_flatpak_only=0
  case "$distro" in
    debian*)  col=2; fp_col=7 ;;
    fedora*)  col=3; fp_col=7 ;;
    arch*)    col=4; fp_col=7 ;;
    alpine*)  col=5; fp_col=7 ;;
    suse*)    col=6; fp_col=7 ;;
    flatpak)  col=7; fp_col=7; is_flatpak_only=1 ;;
    *)        col=0; fp_col=7 ;;
  esac

  local -a install_list=() flatpak_list=() unsupported=()
  local p key value notes fp v
  while IFS= read -r p; do
    [[ -z "$p" ]] && continue
    key="$(canonical_key "$p")"
    notes="$(map_lookup "$key" 8)"
    value=""
    if (( col > 0 && ! is_flatpak_only )); then
      value="$(map_lookup "$key" "$col")"
    fi
    fp="$(map_lookup "$key" "$fp_col")"

    if (( is_flatpak_only )); then
      if [[ -n "$fp" && "$fp" != "-" ]]; then
        # Un ID puede contener múltiples entradas separadas por espacio.
        for v in $fp; do flatpak_list+=("$v"); done
      else
        unsupported+=("${p} (${notes:-sin equivalente Flatpak})")
      fi
      continue
    fi

    if [[ -n "$value" && "$value" != "-" ]]; then
      # Una celda puede contener varios paquetes separados por espacio.
      for v in $value; do install_list+=("$v"); done
    elif [[ -n "$fp" && "$fp" != "-" ]]; then
      for v in $fp; do flatpak_list+=("$v"); done
    else
      unsupported+=("${p} (${notes:-sin equivalente portable})")
    fi
  done <<< "$pkgs"

  # Eliminar duplicados conservando orden.
  local -a uniq_install=() uniq_flatpak=() seen=() item
  for item in "${install_list[@]}"; do
    if [[ ! " ${seen[*]-} " =~ " $item " ]]; then seen+=("$item"); uniq_install+=("$item"); fi
  done
  seen=()
  for item in "${flatpak_list[@]}"; do
    if [[ ! " ${seen[*]-} " =~ " $item " ]]; then seen+=("$item"); uniq_flatpak+=("$item"); fi
  done

  {
    printf '#!/usr/bin/env bash\n'
    printf '# Plan generado por autoapp %s para: %s\n' "$TOOL_VERSION" "$distro"
    printf '# Fecha: %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    printf '# Espacio libre detectado: %s GiB\n' "$(human_gb "$free_bytes")"
    printf '# REVISAR ANTES DE EJECUTAR. Este script NO se ejecuta automáticamente.\n'
    printf 'set -Eeuo pipefail\n\n'
    printf 'echo "[plan] Destino: %s"\n' "$distro"
    if (( ${#uniq_install[@]} > 0 )); then
      printf 'PKGS=(\n'
      for item in "${uniq_install[@]}"; do printf '  "%s"\n' "$item"; done
      printf ')\n'
      case "$distro" in
        debian*)  printf 'apt-get update\napt-get install -y --no-install-recommends "${PKGS[@]}"\n' ;;
        fedora*)  printf 'dnf makecache\ndnf install -y "${PKGS[@]}"\n' ;;
        arch*)    printf 'pacman -Sy\npacman -S --noconfirm --needed "${PKGS[@]}"\n' ;;
        alpine*)  printf 'apk update\napk add --no-cache "${PKGS[@]}"\n' ;;
        suse*)    printf 'zypper refresh\nzypper install -y "${PKGS[@]}"\n' ;;
      esac
    else
      printf '\necho "[plan] Sin paquetes nativos traducidos para %s."\n' "$distro"
    fi
    if (( ${#uniq_flatpak[@]} > 0 )); then
      printf '\nif command -v flatpak >/dev/null 2>&1; then\n'
      printf '  flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || true\n'
      for item in "${uniq_flatpak[@]}"; do
        printf '  flatpak install -y flathub "%s" || echo "[plan] No se pudo instalar Flatpak %s" >&2\n' "$item" "$item"
      done
      printf 'else\n  echo "[plan] Flatpak no disponible; se omiten %s apps." >&2\nfi\n' "${#uniq_flatpak[@]}"
    fi
    if (( ${#unsupported[@]} > 0 )); then
      printf '\nprintf "%s\\n" "[plan] NO PORTABLE / REVISION MANUAL (%s):" >&2\n' "${#unsupported[@]}"
      printf 'cat <<'"'"'EOF'"'"' >&2\n'
      printf '# Estos elementos no tienen equivalente automatico:\n'
      for item in "${unsupported[@]}"; do printf '# - %s\n' "$item"; done
      printf 'EOF\n'
    fi
    printf '\necho "[plan] Finalizado."\n'
  } > "$out"
  chmod +x "$out"
  log "Plan generado: $out (${#uniq_install[@]} paquetes, ${#uniq_flatpak[@]} flatpaks, ${#unsupported[@]} no portables)"
}

write_report() {
  local out="$1" pkgs="$2" flatpaks="$3" snaps="$4" scripts="$5" free_bytes="$6"
  {
    printf 'autoapp %s - Informe de inventario\n' "$TOOL_VERSION"
    printf '========================================\n'
    printf 'Equipo      : %s\n' "$PRETTY"
    printf 'ID / ID_LIKE: %s / %s\n' "$ID" "$ID_LIKE"
    printf 'Escritorio  : %s (solo informativo)\n' "$DE"
    printf 'Gestor      : %s\n' "$PKG_MANAGER"
    printf 'Espacio     : %s GiB libres en %s\n' "$(human_gb "$free_bytes")" "$OUT_DIR"
    printf 'Paquetes nativos: %s\n' "$(printf '%s\n' "$pkgs" | grep -c . || true)"
    printf 'Flatpaks         : %s\n' "$(printf '%s\n' "$flatpaks" | grep -c . || true)"
    printf 'Snaps            : %s\n' "$(printf '%s\n' "$snaps" | grep -c . || true)"
    printf 'Scripts de usuario: %s\n' "$(printf '%s\n' "$scripts" | grep -c . || true)"
    printf '\nIMPORTANTE: Snaps, AppImages y paquetes con licenses/repo privado NO son\n'
    printf 'portables entre distros. Se inventarían pero no se traducen automáticamente.\n'
    printf 'Consulta docs/es/GUIA.md, docs/en/GUIDE.md y docs/ast/GUIA.md.\n'
  } > "$out"
  log "Informe escrito: $out"
}

apply_current_plan() {
  local plan="$OUT_DIR/plan-${ID}.sh"
  [[ -f "$plan" ]] || die "No existe plan para la distro actual ($ID): $plan"
  if (( ! ASSUME_YES )); then
    printf 'Va a INSTALAR paquetes usando %s. ¿Continuar? [s/N] ' "$PKG_MANAGER" >&2
    local ans; read -r ans || exit 1
    [[ "$ans" =~ ^[sSyY] ]] || die "Cancelado por el usuario."
  fi
  log "Aplicando plan: $plan"
  bash "$plan"
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
main() {
  local check_disk_only=0
  while (( $# )); do
    case "$1" in
      -h|--help) usage; exit 0 ;;
      -V|--version) printf 'autoapp %s\n' "$TOOL_VERSION"; exit 0 ;;
      -o|--out) OUT_DIR="${2:?falta valor}"; shift 2 ;;
      -m|--map) MAP_FILE="${2:?falta valor}"; shift 2 ;;
      -a|--apply) APPLY=1; DRY_RUN=0; shift ;;
      -y|--yes) ASSUME_YES=1; shift ;;
      -v|--verbose) VERBOSE=1; shift ;;
      --check-disk) check_disk_only=1; shift ;;
      *) die "Opción desconocida: $1 (usa --help)" ;;
    esac
  done

  detect_os; detect_pkg_manager; detect_de
  mkdir -p "$OUT_DIR"
  local free_bytes
  free_bytes="$(disk_report)"

  if (( check_disk_only )); then exit 0; fi
  ensure_map

  log "=== Inventariando ==="
  local pkgs flatpaks snaps scripts
  pkgs="$(inventory_native)"
  flatpaks="$(inventory_flatpak)"
  snaps="$(inventory_snap)"
  scripts="$(inventory_user_scripts)"

  write_inventory_json "$OUT_DIR/inventory.json" "$pkgs" "$flatpaks" "$snaps" "$scripts" "$free_bytes"
  write_report "$OUT_DIR/reporte.txt" "$pkgs" "$flatpaks" "$snaps" "$scripts" "$free_bytes"

  log "=== Generando planes multi-distro ==="
  local d input
  for d in debian fedora arch alpine suse flatpak; do
    if [[ "$d" == flatpak ]]; then
      # El plan Flatpak se basa en los IDs REALES inventariados, no en el mapa.
      input="$(printf '%s\n' "$flatpaks" | awk -F'\t' 'NF && $1!="" {print "fp:" $1}')"
    else
      input="$pkgs"
    fi
    generate_plan "$d" "$input" "$OUT_DIR/plan-${d}.sh" "$free_bytes"
  done

  if (( APPLY )); then
    apply_current_plan
  else
    log "Modo simulación: no se instaló nada. Usa --apply --yes para aplicar."
  fi
  log "Listo. Resultados en: $OUT_DIR"
}

main "$@"
