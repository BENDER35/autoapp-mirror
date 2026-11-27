#!/usr/bin/env bash
# Construye el ZIP de release de autoapp-mirror.
# Uso: ./scripts/build-release.sh 1.0.0
set -Eeuo pipefail

VERSION="${1:-1.0.0}"
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
DIST="$ROOT/dist"
NAME="autoapp-mirror-${VERSION}"
TMPROOT="${TMPDIR:-/tmp}/autoapp-mirror-build"
mkdir -p "$TMPROOT"
STAGE="$(mktemp -d "$TMPROOT/${NAME}.XXXXXX")"
trap 'rm -rf "$STAGE"' EXIT

log() { printf '[release] %s\n' "$*" >&2; }

mkdir -p "$DIST" "$STAGE/$NAME"

cp -a "$ROOT/scripts" "$STAGE/$NAME/"
cp -a "$ROOT/data" "$STAGE/$NAME/"
cp -a "$ROOT/docs" "$STAGE/$NAME/"
cp -a "$ROOT/mirroring" "$STAGE/$NAME/"
cp -a "$ROOT/.github" "$STAGE/$NAME/"
[[ -f "$ROOT/.gitlab-ci.yml" ]] && cp "$ROOT/.gitlab-ci.yml" "$STAGE/$NAME/"
[[ -f "$ROOT/README.md" ]] && cp "$ROOT/README.md" "$STAGE/$NAME/"
[[ -f "$ROOT/LICENSE" ]] && cp "$ROOT/LICENSE" "$STAGE/$NAME/"

# Inventario de ejemplo reproducible (sin instalar nada).
log "Generando inventario de ejemplo..."
mkdir -p "$STAGE/$NAME/inventory"
if [[ -x "$ROOT/scripts/autoapp.sh" ]]; then
  "$ROOT/scripts/autoapp.sh" --out "$STAGE/$NAME/inventory" >/dev/null 2>&1 || \
    log "No se pudo generar el inventario de ejemplo (se omite)."
fi

log "Comprimiendo..."
( cd "$STAGE" && zip -qr "$DIST/${NAME}.zip" "$NAME" )
log "Creado: $DIST/${NAME}.zip"
ls -lh "$DIST/${NAME}.zip" >&2
