#!/bin/sh
# shellsurf installer
# Usage: curl -fsSL https://shellsurf.com/install.sh | sh
set -e

REPO="samuelahmed/shellsurf-releases"
VERSION="v0.1.0"
INSTALL_DIR="${SHELLSURF_INSTALL_DIR:-$HOME/.local/bin}"

# Detect OS and architecture
OS="$(uname -s)"
ARCH="$(uname -m)"

case "$OS" in
  Linux)  os="unknown-linux-gnu" ;;
  Darwin) os="apple-darwin" ;;
  *)      echo "Unsupported OS: $OS" >&2; exit 1 ;;
esac

case "$ARCH" in
  x86_64|amd64)  arch="x86_64" ;;
  aarch64|arm64) arch="aarch64" ;;
  *)             echo "Unsupported architecture: $ARCH" >&2; exit 1 ;;
esac

TARGET="${arch}-${os}"
TARBALL="shellsurf-${VERSION}-${TARGET}.tar.gz"
URL="https://github.com/${REPO}/releases/download/${VERSION}/${TARBALL}"

echo "Installing shellsurf ${VERSION} for ${TARGET}..."

# Create install directory
mkdir -p "$INSTALL_DIR"

# Download and extract
TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

if command -v curl >/dev/null 2>&1; then
  curl -fsSL "$URL" -o "$TMPDIR/$TARBALL"
elif command -v wget >/dev/null 2>&1; then
  wget -q "$URL" -O "$TMPDIR/$TARBALL"
else
  echo "Error: curl or wget required" >&2
  exit 1
fi

tar xzf "$TMPDIR/$TARBALL" -C "$TMPDIR"
mv "$TMPDIR/shellsurf" "$INSTALL_DIR/shellsurf"
chmod +x "$INSTALL_DIR/shellsurf"

echo ""
echo "shellsurf installed to $INSTALL_DIR/shellsurf"

# Check if install dir is in PATH
case ":$PATH:" in
  *":$INSTALL_DIR:"*) ;;
  *)
    echo ""
    echo "Add to your PATH:"
    echo "  export PATH=\"$INSTALL_DIR:\$PATH\""
    echo ""
    echo "Or add that line to your ~/.bashrc or ~/.zshrc"
    ;;
esac

echo ""
echo "Run 'shellsurf' to get started."
