#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm cargo nodejs npm webkit2gtk-4.1

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

echo "Building NSCB Desktop..."
echo "---------------------------------------------------------------"
REPO="https://github.com/cxfcxf/nscb-desktop"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone --depth 1 "$REPO" ./nscb-desktop
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./nscb-desktop
npm install
npm audit fix
npx tauri build --no-bundle
node scripts/portable.mjs
mv -v "./release/NSCB Desktop/nscb-desktop" ../AppDir/bin/
