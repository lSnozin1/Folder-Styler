#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

BIN_DIR="${HOME}/.local/bin"
APP_DIR="${HOME}/.local/share/applications"
ICON_DIR="${HOME}/.local/share/icons/hicolor/scalable/apps"

BIN_FILES=("folder-icon" "folder-icon-gui")
DESKTOP_FILE="folder-icon-gui.desktop"
ICON_FILE="folder-icon-gui.svg"

uninstall() {
    echo "Removing Folder-Styler symlinks from ~/.local..."
    for bin in "${BIN_FILES[@]}"; do
        rm -f "${BIN_DIR}/${bin}"
    done
    rm -f "${APP_DIR}/${DESKTOP_FILE}"
    rm -f "${ICON_DIR}/${ICON_FILE}"

    if command -v update-desktop-database >/dev/null 2>&1; then
        update-desktop-database "${APP_DIR}" >/dev/null 2>&1 || true
    fi
    echo "Uninstall complete."
}

install_links() {
    echo "Installing Folder-Styler from ${SCRIPT_DIR}..."

    mkdir -p "${BIN_DIR}" "${APP_DIR}" "${ICON_DIR}"

    for bin in "${BIN_FILES[@]}"; do
        src="${SCRIPT_DIR}/${bin}"
        if [[ ! -f "${src}" ]]; then
            echo "Error: Required executable not found: ${src}" >&2
            exit 1
        fi
        chmod +x "${src}"
        ln -sf "${src}" "${BIN_DIR}/${bin}"
        echo "  Linked ${BIN_DIR}/${bin} -> ${src}"
    done

    if [[ -f "${SCRIPT_DIR}/${DESKTOP_FILE}" ]]; then
        ln -sf "${SCRIPT_DIR}/${DESKTOP_FILE}" "${APP_DIR}/${DESKTOP_FILE}"
        echo "  Linked ${APP_DIR}/${DESKTOP_FILE} -> ${SCRIPT_DIR}/${DESKTOP_FILE}"
    else
        echo "  Skipped ${DESKTOP_FILE} (not found in ${SCRIPT_DIR})"
    fi

    if [[ -f "${SCRIPT_DIR}/${ICON_FILE}" ]]; then
        ln -sf "${SCRIPT_DIR}/${ICON_FILE}" "${ICON_DIR}/${ICON_FILE}"
        echo "  Linked ${ICON_DIR}/${ICON_FILE} -> ${SCRIPT_DIR}/${ICON_FILE}"
    else
        echo "  Skipped ${ICON_FILE} (not found in ${SCRIPT_DIR})"
    fi

    if command -v update-desktop-database >/dev/null 2>&1; then
        update-desktop-database "${APP_DIR}" >/dev/null 2>&1 || true
    fi

    if command -v gtk-update-icon-cache >/dev/null 2>&1; then
        gtk-update-icon-cache -f -t "${HOME}/.local/share/icons/hicolor" >/dev/null 2>&1 || true
    fi

    echo "Done! Ensure ${BIN_DIR} is in your PATH."
}

case "${1:-}" in
    --uninstall|-u)
        uninstall
        ;;
    --help|-h)
        echo "Usage: ./install.sh [--uninstall]"
        ;;
    "")
        install_links
        ;;
    *)
        echo "Unknown option: $1" >&2
        echo "Usage: ./install.sh [--uninstall]" >&2
        exit 1
        ;;
esac