#!/usr/bin/env bash
#
# backup.sh - Sauvegarde automatique de fichiers/dossiers vers un dossier horodate.
# Usage : ./backup.sh chemin1 [chemin2 ...]
#
# Exemple :
#   ./backup.sh ~/.config/monapp ~/Documents/projet-important

set -euo pipefail

DEST_ROOT="./Backups"
STAMP=$(date +"%Y-%m-%d_%H%M%S")
DEST="${DEST_ROOT}/config-systeme_${STAMP}"
LOG="./backup.log"

log() {
  local msg="[$(date +"%Y-%m-%d %H:%M:%S")] $1"
  echo "$msg"
  echo "$msg" >> "$LOG"
}

if [ "$#" -eq 0 ]; then
  log "ERREUR : aucun chemin fourni. Usage: ./backup.sh chemin1 [chemin2 ...]"
  exit 1
fi

mkdir -p "$DEST"
log "Debut de la sauvegarde vers $DEST"

success=0
fail=0

for src in "$@"; do
  if [ ! -e "$src" ]; then
    log "IGNORE : le chemin source n'existe pas -> $src"
    fail=$((fail + 1))
    continue
  fi

  if cp -r "$src" "$DEST/"; then
    log "OK : $src -> $DEST/"
    success=$((success + 1))
  else
    log "ECHEC : $src"
    fail=$((fail + 1))
  fi
done

log "Sauvegarde terminee : $success reussite(s), $fail echec(s)."
