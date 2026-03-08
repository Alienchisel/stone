#!/usr/bin/env bash
set -euo pipefail

LINPEAS_PATH="/home/pentestlich/tools/exploitation/post-exploitation/linux/linpeas.sh"
WINPEAS64_PATH="/home/pentestlich/tools/exploitation/post-exploitation/windows/winPEASx64.exe"
WINPEAS86_PATH="/home/pentestlich/tools/exploitation/post-exploitation/windows/winPEASx86.exe"

TMP_DIR="$(mktemp -d)"

cleanup() {
    rm -rf "$TMP_DIR"
}

trap cleanup EXIT

echo "[+] Updating PEAS tools..."

echo "[+] Downloading linPEAS..."
curl -L \
    "https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh" \
    -o "$TMP_DIR/linpeas.sh"

echo "[+] Downloading winPEAS x64..."
curl -L \
    "https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEASx64.exe" \
    -o "$TMP_DIR/winPEASx64.exe"

echo "[+] Downloading winPEAS x86..."
curl -L \
    "https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEASx86.exe" \
    -o "$TMP_DIR/winPEASx86.exe"

echo "[+] Replacing local files..."
mv "$TMP_DIR/linpeas.sh" "$LINPEAS_PATH"
mv "$TMP_DIR/winPEASx64.exe" "$WINPEAS64_PATH"
mv "$TMP_DIR/winPEASx86.exe" "$WINPEAS86_PATH"

chmod 755 "$LINPEAS_PATH"

echo "[+] Done. linPEAS and winPEAS have been updated."