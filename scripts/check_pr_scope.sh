#!/usr/bin/env bash
# Cek otomatis: 1 PR cuma boleh menyentuh 1 folder packages/<modul>.
# Mencegah "mengacak-acak file lain" lolos tanpa disadari sebelum manusia review.
# Lihat docs/ROLES.md untuk aturan lengkapnya.
set -euo pipefail

BASE_REF="${1:-origin/main}"

changed_files=$(git diff --name-only "${BASE_REF}...HEAD")

if [ -z "$changed_files" ]; then
  echo "Tidak ada file berubah dibanding ${BASE_REF}."
  exit 0
fi

echo "File yang berubah:"
echo "$changed_files"
echo

pkg_scopes=$(echo "$changed_files" | grep -E '^packages/[^/]+/' | cut -d/ -f1-2 | sort -u || true)
scope_count=$(echo "$pkg_scopes" | sed '/^$/d' | wc -l | tr -d ' ')

if [ "$scope_count" -gt 1 ]; then
  echo "❌ PR ini menyentuh lebih dari 1 folder packages/<modul>:"
  echo "$pkg_scopes"
  echo
  echo "Aturan (docs/ROLES.md, docs/GIT_WORKFLOW.md): 1 PR = 1 modul."
  echo "Pisahkan jadi beberapa PR, satu PR per folder packages/<modul>."
  exit 1
fi

echo "✅ Scope check lolos. Modul yang disentuh: ${pkg_scopes:-"(tidak ada di packages/, cuma docs/config)"}"
