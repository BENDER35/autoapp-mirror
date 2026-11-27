#!/usr/bin/env bash
# Sincronización bidireccional manual GitHub <-> GitLab.
# Uso:
#   GITLAB_TOKEN=xxx GITHUB_TOKEN=yyy ./mirroring/sync-bidirectional.sh \
#     https://github.com/USUARIO/autoapp-mirror.git \
#     https://gitlab.com/GRUPO/autoapp-mirror.git
set -Eeuo pipefail

GH_URL="${1:?Falta la URL de GitHub}"
GL_URL="${2:?Falta la URL de GitLab}"
: "${GITLAB_TOKEN:?Falta GITLAB_TOKEN}"
: "${GITHUB_TOKEN:?Falta GITHUB_TOKEN}"

WORK="$(mktemp -d /tmp/opencode/autoapp-mirror.XXXXXX)"
trap 'rm -rf "$WORK"' EXIT

log() { printf '[sync] %s\n' "$*" >&2; }

log "Clonando espejo desde GitHub..."
git clone --mirror "$GH_URL" "$WORK/repo.git"

log "Configurando remotos..."
cd "$WORK/repo.git"
git remote add gitlab "$GL_URL" 2>/dev/null || true

# Inyectar credenciales sin guardarlas en .git/config de forma permanente.
git config --global --unset-all credential.helper 2>/dev/null || true
printf 'protocol=https\nhost=gitlab.com\nusername=oauth2\npassword=%s\n\n' "$GITLAB_TOKEN" \
  | git credential-store --file "$WORK/gl.creds" store
printf 'protocol=https\nhost=github.com\nusername=x-access-token\npassword=%s\n\n' "$GITHUB_TOKEN" \
  | git credential-store --file "$WORK/gh.creds" store

log "GitHub -> GitLab..."
GIT_CONFIG_COUNT=2 \
GIT_CONFIG_KEY_0=credential.helper GIT_CONFIG_VALUE_0="store --file=$WORK/gl.creds" \
GIT_CONFIG_KEY_1=credential.helper GIT_CONFIG_VALUE_1="store --file=$WORK/gl.creds" \
  git push --mirror gitlab

log "GitLab -> GitHub (traer cambios que pudiera haber en GitLab)..."
GIT_CONFIG_COUNT=2 \
GIT_CONFIG_KEY_0=credential.helper GIT_CONFIG_VALUE_0="store --file=$WORK/gh.creds" \
GIT_CONFIG_KEY_1=credential.helper GIT_CONFIG_VALUE_1="store --file=$WORK/gl.creds" \
  git fetch gitlab '+refs/heads/*:refs/remotes/gitlab/*'

GIT_CONFIG_COUNT=1 \
GIT_CONFIG_KEY_0=credential.helper GIT_CONFIG_VALUE_0="store --file=$WORK/gh.creds" \
  git push origin 'refs/remotes/gitlab/*:refs/heads/*'

log "Sincronización bidireccional completada."
