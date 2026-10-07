#!/bin/bash
# Usage: download.sh DOWNLOAD_DIR ARCH LIST...
# Downloads the packages of each list into DOWNLOAD_DIR.
#  - *.urls lists contain package URLs. Previously downloaded files are reused.
#  - *.packages lists contain package names from the build host's Ubuntu
#    archive. These are always downloaded again to pick up archive updates.
set -euo pipefail

download_dir="$1"
arch="$2"
shift 2
scripts="$(dirname "$0")"

mkdir -p "$download_dir"
for list in "$@"; do
  case "$list" in
    *.urls)
      "$scripts/list.sh" "$list" | while read -r url; do
        deb="$download_dir/$(basename "$url")"
        if [ ! -f "$deb" ]; then
          wget -nv -O "$deb.tmp" "$url"
          mv "$deb.tmp" "$deb"
        fi
      done
      ;;
    *.packages)
      "$scripts/list.sh" "$list" | while read -r package; do
        tmp="$(mktemp -d)"
        (cd "$tmp" && apt-get download "$package:$arch")
        mv "$tmp"/*.deb "$download_dir/archive_$package.deb"
        rmdir "$tmp"
      done
      ;;
    *)
      echo "Unknown list type: $list" >&2
      exit 1
      ;;
  esac
done
