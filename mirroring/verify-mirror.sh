#!/usr/bin/env bash
# Verifica que dos repositorios (GitHub y GitLab) estén sincronizados.
# Compara el HEAD de la rama main (o master) en ambos remotos.
# Uso:
#   ./mirroring/verify-mirror.sh <url-github> <url-gitlab> [rama]
set -Eeuo pipefail

GH_URL="${1:?Falta la URL de GitHub}"
GL_URL="${2:?Falta la URL de GitLab}"
BRANCH="${3:-main}"

TMPROOT="${TMPDIR:-/tmp}/autoapp-mirror-verify"
mkdir -p "$TMPROOT"
WORK="$(mktemp -d "$TMPROOT/verify.XXXXXX")"
trap 'rm -rf "$WORK"' EXIT

log() { printf '[verify] %s\n' "$*" >&2; }
die() { printf '[verify] FALLO: %s\n' "$*" >&2; exit 1; }

remote_head() {
  local url="$1" ref="$2" out
  if ! out="$(git ls-remote "$url" "refs/heads/$ref" 2>"$WORK/err")"; then
    log "No se pudo consultar $url:"
    cat "$WORK/err" >&2
    return 1
  fi
  [[ -n "$out" ]] || return 1
  printf '%s\n' "$out" | awk '{print $1}'
}

log "Consultando $BRANCH en GitHub..."
GH_HEAD="$(remote_head "$GH_URL" "$BRANCH")" || die "GitHub no accesible o rama inexistente."

log "Consultando $BRANCH en GitLab..."
GL_HEAD="$(remote_head "$GL_URL" "$BRANCH")" || die "GitLab no accesible o rama inexistente."

log "GitHub HEAD : $GH_HEAD"
log "GitLab HEAD : $GL_HEAD"

if [[ "$GH_HEAD" == "$GL_HEAD" ]]; then
  log "OK: los espejos están sincronizados ($BRANCH)."
  exit 0
else
  die "DESINCRONIZADOS: los HEAD no coinciden. Ejecuta mirroring/sync-bidirectional.sh."
fi
