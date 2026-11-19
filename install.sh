#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/.local/bin"
APP_DIR="$HOME/.local/share/applications"
ICON_DIR="$HOME/.local/share/icons/hicolor/scalable/apps"

CORE_FILE="$SCRIPT_DIR/src/folder_icon_core.py"
CLI_FILE="$SCRIPT_DIR/bin/folder-icon"
GUI_FILE="$SCRIPT_DIR/bin/folder-icon-gui"
SVG_ICON="$SCRIPT_DIR/assets/folder-icon-gui.svg"

for req in "$CORE_FILE" "$CLI_FILE" "$GUI_FILE"; do
    if [[ ! -f "$req" ]]; then
        echo "Error: Required file not found: $req" >&2
        exit 1
    fi
done

chmod +x "$CLI_FILE" "$GUI_FILE"

mkdir -p "$BIN_DIR" "$APP_DIR" "$ICON_DIR"
ln -sf "$CLI_FILE" "$BIN_DIR/folder-icon"
ln -sf "$GUI_FILE" "$BIN_DIR/folder-icon-gui"

if [[ -f "$SVG_ICON" ]]; then
    rm -f "$ICON_DIR/folder-icon-gui.svg"
    cp -f "$SVG_ICON" "$ICON_DIR/folder-icon-gui.svg"
    ICON_ENTRY="$ICON_DIR/folder-icon-gui.svg"
else
    ICON_ENTRY="preferences-desktop-color"
fi

rm -f "$APP_DIR/folder-icon-gui.desktop"
cat > "$APP_DIR/folder-icon-gui.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Folder Styler
GenericName=Breeze Folder Icon Customizer
Comment=Customize folder colors and Lucide icons for Dolphin
Exec=$BIN_DIR/folder-icon-gui %F
Icon=$ICON_ENTRY
Terminal=false
Categories=Utility;System;Qt;
Keywords=folder;icon;breeze;dolphin;color;lucide;
StartupNotify=true
EOF
chmod +x "$APP_DIR/folder-icon-gui.desktop"

if command -v gtk-update-icon-cache >/dev/null 2>&1; then
    gtk-update-icon-cache -q -f -t "$HOME/.local/share/icons/hicolor" >/dev/null 2>&1 || true
fi

export PATH="$BIN_DIR:$PATH"
"$BIN_DIR/folder-icon" preset sync

if command -v kbuildsycoca6 >/dev/null 2>&1; then
    kbuildsycoca6 --noincremental >/dev/null 2>&1 || true
fi

if ! python3 -c "import PySide6" >/dev/null 2>&1; then
    echo "Warning: PySide6 is not installed. The CLI works, but the GUI requires:"
    echo "  sudo pacman -S python-pyside6"
fi

case ":$PATH:" in
    *":$BIN_DIR:"*) ;;
    *)
        echo "Warning: $BIN_DIR is not in your PATH."
        echo "  In Fish shell, run: fish_add_path ~/.local/bin"
        ;;
esac

echo "Installed folder-icon and folder-icon-gui to $BIN_DIR"