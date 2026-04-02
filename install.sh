#!/bin/sh
# shellsurf installer
# Usage: curl -fsSL https://shellsurf.com/install.sh | sh
set -e

REPO="samuelahmed/shellsurf-releases"
VERSION="v0.2.0"
INSTALL_DIR="${SHELLSURF_INSTALL_DIR:-$HOME/.local/bin}"

OS="$(uname -s)"
ARCH="$(uname -m)"

case "$OS" in
  Linux)   os="unknown-linux-musl" ;;
  Darwin)  os="apple-darwin" ;;
  MINGW*|MSYS*|CYGWIN*) os="pc-windows-msvc" ;;
  *)       echo "Unsupported OS: $OS" >&2; exit 1 ;;
esac

case "$ARCH" in
  x86_64|amd64)  arch="x86_64" ;;
  aarch64|arm64) arch="aarch64" ;;
  *)             echo "Unsupported architecture: $ARCH" >&2; exit 1 ;;
esac

TARGET="${arch}-${os}"

if [ "$os" = "pc-windows-msvc" ]; then
  EXT="zip"
  BINARY="shellsurf.exe"
else
  EXT="tar.gz"
  BINARY="shellsurf"
fi

ARCHIVE="shellsurf-${VERSION}-${TARGET}.${EXT}"
URL="https://github.com/${REPO}/releases/download/${VERSION}/${ARCHIVE}"

echo "Installing shellsurf ${VERSION} for ${TARGET}..."

mkdir -p "$INSTALL_DIR"

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

if command -v curl >/dev/null 2>&1; then
  curl -fsSL "$URL" -o "$TMPDIR/$ARCHIVE"
elif command -v wget >/dev/null 2>&1; then
  wget -q "$URL" -O "$TMPDIR/$ARCHIVE"
else
  echo "Error: curl or wget required" >&2
  exit 1
fi

if [ "$EXT" = "zip" ]; then
  unzip -q "$TMPDIR/$ARCHIVE" -d "$TMPDIR"
else
  tar xzf "$TMPDIR/$ARCHIVE" -C "$TMPDIR"
fi

mv "$TMPDIR/$BINARY" "$INSTALL_DIR/$BINARY"
chmod +x "$INSTALL_DIR/$BINARY"

echo ""
echo "shellsurf installed to $INSTALL_DIR/$BINARY"

case ":$PATH:" in
  *":$INSTALL_DIR:"*) ;;
  *)
    echo ""
    echo "Add to your PATH:"
    echo "  export PATH=\"$INSTALL_DIR:\$PATH\""
    ;;
esac

echo ""
echo "Run 'shellsurf' to get started."
