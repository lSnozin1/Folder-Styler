# Folder-Styler

**Folder-Styler** is a lightweight command-line tool and desktop application for customizing folder icons on Linux (specifically designed for **KDE Plasma / Dolphin** and the **Breeze** icon theme).

It lets you recolor standard Breeze folders to any hex color and place a crisp **Lucide** icon in the center—either through a graphical interface (`folder-icon-gui`) or directly from your terminal (`folder-icon`).

---

## Table of Contents

- [How It Works](#how-it-works)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Using the Desktop GUI (`folder-icon-gui`)](#using-the-desktop-gui-folder-icon-gui)
- [Using the Command Line (`folder-icon`)](#using-the-command-line-folder-icon)
- [Importing Custom SVG Icons](#importing-custom-svg-icons)
- [Where Files Are Stored](#where-files-are-stored)
- [KDE Dolphin Tips & Troubleshooting](#kde-dolphin-tips--troubleshooting)
- [Uninstalling](#uninstalling)

---

## How It Works

1. Folder-Styler generates a custom SVG icon combining a tinted Breeze-style folder base with an optional centered symbol.
2. The generated SVG is saved in your local cache directory (`~/.local/share/folder-icons/icons/`).
3. A hidden `.directory` configuration file is created (or updated) inside your target folder, telling your file manager which custom icon to display.
4. Any unrelated settings already inside an existing `.directory` file are safely preserved.

---

## Prerequisites

Before installing, make sure your system has:

- **Linux** with a file manager that supports `.directory` desktop entries (such as **KDE Dolphin**).
- **Git** (to clone the repository).
- **Python 3.10 or newer** (the CLI uses only the Python standard library and requires no extra packages).
- **PySide6** (required only if you want to use the graphical desktop app `folder-icon-gui`).

### Installing PySide6

- **Arch Linux / CachyOS / EndeavourOS:**
  ```bash
  sudo pacman -S python-pyside6
  ```
- **Debian / Ubuntu / Linux Mint:**
  ```bash
  sudo apt update && sudo apt install python3-pyside6
  ```
- **Fedora:**
  ```bash
  sudo dnf install python3-pyside6
  ```
- **Via pip (in a virtual environment or user environment):**
  ```bash
  pip install --user PySide6
  ```

---

## Installation

### 1. Clone the Repository

Open your terminal and clone the project to a permanent folder on your computer (for example, `~/Projects/Folder-Styler`):

```bash
git clone [https://github.com/lSnozin1/Folder-Styler.git](https://github.com/lSnozin1/Folder-Styler.git)
cd Folder-Styler
```

> **Important:** Because the installer uses symbolic links pointing back to this cloned folder, keep the `Folder-Styler` directory in a permanent location rather than deleting it after installation.

### 2. Run the Installer

Make `install.sh` executable and run it:

```bash
chmod +x install.sh
./install.sh
```

This script automatically creates the following symlinks in your home directory:

| Symlink Created | Target | Purpose |
| :--- | :--- | :--- |
| `~/.local/bin/folder-icon` | `Folder-Styler/bin/folder-icon` | Command-line tool |
| `~/.local/bin/folder-icon-gui` | `Folder-Styler/bin/folder-icon-gui` | Desktop GUI application |
| `~/.local/share/applications/folder-icon-gui.desktop` | Generated desktop entry | Application menu / launcher entry |
| `~/.local/share/icons/hicolor/scalable/apps/folder-icon-gui.svg` | `Folder-Styler/assets/folder-icon-gui.svg` | Application launcher icon |

### 3. Verify Your `PATH`

Verify that your terminal can find the installed commands:

```bash
which folder-icon folder-icon-gui
```

If nothing is printed or you get a `command not found` error, add `~/.local/bin` to your shell `PATH`:

- **Bash** (`~/.bashrc`):
  ```bash
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
  source ~/.bashrc
  ```
- **Zsh** (`~/.zshrc`):
  ```bash
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
  source ~/.zshrc
  ```
- **Fish** (`~/.config/fish/config.fish`):
  ```fish
  fish_add_path ~/.local/bin
  ```

---

## Quick Start

### Option A: Using the Graphical App

1. Open **Folder Styler** from your application launcher (or run `folder-icon-gui` in a terminal).
2. Pick a **Folder Color** on the left and click a glyph in the **Symbols** tab on the right.
3. Click **Browse...** under **Target Folder** (or drag and drop a folder directly onto the window).
4. Click **Apply to Folder**.
5. If Dolphin is already open to that directory, press `F5` to refresh and see the new icon.

### Option B: Using the Terminal

Style a folder named `~/Games` with a pink color (`#ff6996`) and a `gamepad` symbol:

```bash
folder-icon ~/Games --color "#ff6996" --symbol gamepad
```

---

## Using the Desktop GUI (`folder-icon-gui`)

You can launch the GUI with no arguments, or pass one or more folder paths to pre-load them immediately:

```bash
# Launch normally
folder-icon-gui

# Launch with a single folder selected
folder-icon-gui ~/Projects

# Launch in batch mode with multiple folders queued
folder-icon-gui ~/Projects ~/Music ~/Games
```

### Left Panel (Preview & Controls)

- **Live Preview Box:** Shows how your folder icon looks in real time. Use the top buttons (**Dark**, **Gray**, **Light**, or **Custom** with a hex code / color picker) to test visibility against different backgrounds.
- **Folder Color:** Type any 3-digit or 6-digit hex code (e.g., `#a855f7`), open the system color picker with **Pick...**, or click one of the recent/preset color swatches.
- **Symbol Style:**
  - **Contrast Mode:** Choose **Auto Contrast** (automatically picks white or black based on folder brightness), **White Glyph**, **Black Glyph**, or **Custom Hex**.
  - **Scale Slider:** Resize the center symbol between `25%` and `75%` of the folder width.
  - **Reset:** Restores contrast and scale to default settings.
- **Target Folder:**
  - **Single Mode (default):** Enter a path, click **Browse...**, or drag and drop a folder onto the window. Status text below the box shows whether the folder currently uses the default icon or a custom one.
  - **Multi Mode:** Click the **Multi** toggle button to queue multiple folders and style or revert them all in one click.
- **Action Buttons:**
  - **Apply to Folder(s):** Generates the SVG in the cache and updates each target folder's `.directory` file. Prompts before overwriting an existing `.directory` entry.
  - **Revert Folder(s):** Removes the custom icon from the `.directory` file(s) and restores the default Breeze folder icon.
  - **Save SVG:** Exports a standalone SVG file directly into your configured SVG save directory without modifying any folder's `.directory` file.

### Right Tabs

1. **Symbols:**
   - Browse all built-in symbols and imported custom symbols (`*` marks custom imports).
   - Search by symbol name or by any alias pointing to that symbol.
   - Select **none** to create a plain tinted folder with no glyph.
   - Click **+ Import SVG...** (or drag and drop `.svg` files onto the window) to import local `24×24` Lucide SVGs.
2. **Browse Lucide:**
   - Fetches the full official Lucide icon catalog from GitHub.
   - Click any icon in the list to download a temporary preview and see it rendered live on your colored folder on the left.
   - Click **Import Symbol** to save it permanently under its original name, or **Import As...** to save it under a custom name.
3. **Aliases:**
   - Create short aliases for any built-in or custom symbol (for example, mapping `pad` → `gamepad`).
   - Double-click any row in the table to jump straight to that symbol in the **Symbols** tab.
4. **Cache Cleanup:**
   - Scans your tracked folder registry and home directories to find generated SVGs in `~/.local/share/folder-icons/icons/` that are no longer used by any `.directory` file.
   - Select the unused SVGs you want to remove and click **Delete Selected** to free up space.
5. **Options:**
   - Set the default **SVG Save Path** used when clicking **Save SVG** on the left panel.
   - View the exact filesystem paths used by Folder-Styler.

---

## Using the Command Line (`folder-icon`)

Run `folder-icon --help` at any time for a full summary of commands and flags.

### Apply an Icon to One or More Folders

```bash
# Basic usage (color + symbol)
folder-icon ~/Games --color "#ff6996" --symbol gamepad

# Short flags (-c for --color, -s for --symbol)
folder-icon ~/Projects -c "#a855f7" -s code

# Apply to multiple folders at once
folder-icon ~/Work/ClientA ~/Work/ClientB -c "#3daee9" -s folder

# Plain colored folder without a center symbol
folder-icon ~/Downloads -c "#22c55e" --symbol none

# Force a custom symbol color and adjust symbol scale (0.25 to 0.75)
folder-icon ~/Notes -c "#f59e0b" -s book --symbol-color "#1e1b2e" --scale 0.50

# Skip confirmation prompts when overwriting existing .directory files
folder-icon ~/Games -c "#ec4899" -s gamepad --yes
```

### Generate an SVG Without Applying It to a Folder

```bash
# Save to the default cache directory (~/.local/share/folder-icons/icons/)
folder-icon --color "#ff6996" --symbol heart

# Save to a specific file path
folder-icon --color "#ff6996" --symbol heart --out ~/Pictures/pink-heart-folder.svg
```

### Check Folder Icon Status

```bash
folder-icon status ~/Games ~/Projects ~/Downloads
```

### Revert Folders Back to Default Breeze Icons

```bash
# Revert a single folder
folder-icon reset ~/Games

# Revert multiple folders without confirmation prompts
folder-icon reset ~/Games ~/Projects --yes
```

### List Available Symbols & Aliases

```bash
folder-icon list
```

### Manage Symbol Aliases

```bash
# Create an alias (allows using -s pad instead of -s gamepad)
folder-icon alias gamepad pad

# Remove an alias
folder-icon alias --remove pad
```

### Clean Up Orphaned Cached Icons

```bash
# Interactive cleanup of unused SVGs in ~/.local/share/folder-icons/icons/
folder-icon gc
```

---

## Importing Custom SVG Icons

You can extend Folder-Styler with any icon from [lucide.dev](https://lucide.dev) or your own matching SVGs:

- **From the GUI:** Use the **Browse Lucide** tab to search and import icons online, or click **+ Import SVG...** in the **Symbols** tab (or drag-and-drop an `.svg` file onto the window).
- **From the CLI:**
  ```bash
  # Import using the filename as the symbol name
  folder-icon import ~/Downloads/rocket.svg

  # Import with a custom name
  folder-icon import ~/Downloads/cat.svg --name kitty
  ```

### Custom SVG Requirements

To ensure imported icons scale and recolor properly inside Breeze folders, custom SVGs must follow Lucide's standard format:

- `viewBox="0 0 24 24"` (or `width="24"` and `height="24"`).
- Monochrome stroke-based vector primitives (`<path>`, `<circle>`, `<rect>`, `<line>`, `<polyline>`, `<polygon>`, `<ellipse>`).
- No embedded `<script>`, `<image>`, `<style>`, or `<foreignObject>` tags.

---

## Where Files Are Stored

Folder-Styler keeps all generated assets and configuration inside `~/.local/share/folder-icons/`:

| Path | Description |
| :--- | :--- |
| `~/.local/share/folder-icons/icons/` | Generated folder SVGs linked by `.directory` files. |
| `~/.local/share/folder-icons/symbols/` | Custom `24×24` Lucide SVGs you have imported. |
| `~/.local/share/folder-icons/aliases.json` | Saved symbol alias definitions. |
| `~/.local/share/folder-icons/registry.json` | List of folders styled by Folder-Styler (used by `gc` / Cache Cleanup). |
| `~/.local/share/folder-icons/gui_state.json` | GUI preferences, recent color swatches, last folder, and SVG save path. |
| `~/.local/share/folder-icons/lucide_index.json` | Cached list of official Lucide icon names for the GUI browser. |

Inside each styled directory, Folder-Styler writes a standard KDE desktop entry file named `.directory`:

```ini
[Desktop Entry]
Icon=/home/username/.local/share/folder-icons/icons/folder-gamepad-ff6996.svg
```

---

## KDE Dolphin Tips & Troubleshooting

### Why is Dolphin drawing a small thumbnail preview on top of my custom folder icon?

By default, KDE Dolphin overlays thumbnails of images or SVGs located *inside* a folder on top of that folder's icon. To prevent this from covering your custom folder icons:

1. Open **Dolphin**.
2. Open **Configure Dolphin** (`Ctrl+Shift+,` or menu `≡` → **Configure** → **Configure Dolphin...**).
3. Go to **Interface** → **Previews** (or **General** → **Previews** on older versions).
4. Uncheck **Folders** and click **OK**.
5. Press `F5` in Dolphin to refresh.

### Dolphin Didn't Update the Icon Immediately

- Press `F5` inside the parent folder in Dolphin to reload directory metadata.
- If KDE's icon cache is still holding an older version, close and reopen Dolphin or clear the thumbnail/icon cache:
  ```bash
  rm -f ~/.cache/icon-cache.kcache
  ```

### Giving a Git Repository or Project Folder a Portable Icon

If you want a specific project folder to keep its custom icon even when cloned or moved to another machine, place the SVG file directly inside that folder and use a relative `./` path in its `.directory` file:

```ini
[Desktop Entry]
Icon=./my-project-icon.svg
```

Because this SVG lives inside your project rather than `~/.local/share/folder-icons/icons/`, Folder-Styler's **Cache Cleanup** will never delete it.

---

## Uninstalling

To remove all symlinks installed in `~/.local/bin`, `~/.local/share/applications`, and `~/.local/share/icons`:

```bash
cd /path/to/Folder-Styler
./install.sh --uninstall
```

If you also want to delete all cached icons, custom symbols, and settings:

```bash
rm -rf ~/.local/share/folder-icons
```