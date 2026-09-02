#!/usr/bin/env bash
set -euo pipefail

FLUTTER_VERSION="${FLUTTER_VERSION:-3.44.4}"
FLUTTER_DIR="$HOME/flutter"

echo "=== Pincus Work – Flutter Web Build ==="
echo "Flutter-Version: $FLUTTER_VERSION"

if [ ! -x "$FLUTTER_DIR/bin/flutter" ]; then
  echo "Flutter SDK wird installiert..."

  rm -rf "$FLUTTER_DIR"

  curl -L \
    "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" \
    -o /tmp/flutter.tar.xz

  tar -xf /tmp/flutter.tar.xz -C "$HOME"
  rm -f /tmp/flutter.tar.xz
fi

export PATH="$FLUTTER_DIR/bin:$PATH"

flutter --version
flutter config --enable-web

echo "=== Dependencies ==="
flutter pub get

echo "=== Flutter Web Release Build ==="
flutter build web --release

echo "=== Build erfolgreich ==="
ls -lah build/web
