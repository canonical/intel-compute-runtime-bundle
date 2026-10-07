#!/bin/bash
# Usage: install.sh DESTDIR DOWNLOAD_DIR LIST...
# Installs the downloaded packages of each list into DESTDIR, one list at a
# time and in the given order, so later lists override files from earlier ones.
set -euo pipefail

destdir="$1"
download_dir="$2"
shift 2
scripts="$(dirname "$0")"

mkdir -p "$destdir"
destdir="$(realpath "$destdir")"

for list in "$@"; do
  entries="$("$scripts/list.sh" "$list")"
  if [ -z "$entries" ]; then
    continue
  fi

  debs=()
  while read -r entry; do
    case "$list" in
      *.packages) debs+=("$download_dir/archive_$entry.deb") ;;
      *) debs+=("$download_dir/$(basename "$entry")") ;;
    esac
  done <<< "$entries"

  if [ "${#debs[@]}" -gt 0 ]; then
    dpkg --root="$destdir" --force-all -i "${debs[@]}"
  fi
done

# The ocloc packages register update-alternatives links with absolute targets
# outside the snap, which fail store review. They are not required.
for link in etc/alternatives/ocloc usr/bin/ocloc; do
  if [ -L "$destdir/$link" ]; then
    rm "$destdir/$link"
  fi
done
