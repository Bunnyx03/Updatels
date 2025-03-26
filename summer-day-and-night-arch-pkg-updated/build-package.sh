#!/bin/bash

# Script to build and install the Summer Day and Night theme package
# This script should be run on an Arch Linux system

echo "=== Summer Day and Night Theme - Arch Linux Package Builder ==="
echo ""

# Check if running on Arch Linux
if ! command -v pacman &> /dev/null; then
    echo "Error: This script must be run on an Arch Linux system."
    exit 1
fi

# Create temporary directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Copy PKGBUILD and install file
cat > PKGBUILD << 'EOF'
# Maintainer: Your Name <your.email@example.com>

pkgname=summer-day-and-night-theme
pkgver=1.0.0
pkgrel=1
pkgdesc="Summer Day and Night Hyprland rice theme"
arch=('any')
url="https://github.com/yourusername/summer-day-and-night"
license=('MIT')
depends=(
  'hyprland-meta'
  'waybar-git'
  'wofi'
  'kitty-git'
  'nemo-git'
  'brave-nightly-git'
  'ttf-jetbrains-mono-nerd'
  'python-pyquery'
  'cliphist'
  'wl-clipboard'
  'dunst'
  'nitch'
  'python'
  'polkit-kde-agent'
)
optdepends=(
  'everforest-gtk-theme-git: GTK theme for the rice'
  'everforest-icon-theme-git: Icon theme for the rice'
  'visual-studio-code-bin: Recommended editor with Everforest theme'
  'zsh: For P10K prompt'
  'zsh-theme-powerlevel10k: For P10K prompt'
  'i3lock: For screen locking'
  'betterlockscreen: For improved screen locking'
)
source=("$pkgname-$pkgver.zip")
sha256sums=('SKIP')
install="$pkgname.install"

package() {
  # Create directories
  mkdir -p "$pkgdir/usr/share/$pkgname"
  mkdir -p "$pkgdir/etc/skel/.config/hypr"
  mkdir -p "$pkgdir/etc/skel/.config/waybar"
  mkdir -p "$pkgdir/etc/skel/.config/wofi"
  mkdir -p "$pkgdir/etc/skel/.config/kitty"
  
  # Copy files to package directory
  cp -r "$srcdir/summer-day-and-night-main/"* "$pkgdir/usr/share/$pkgname/"
  
  # Copy configuration files to skeleton directory
  cp -r "$srcdir/summer-day-and-night-main/hypr/"* "$pkgdir/etc/skel/.config/hypr/"
  cp -r "$srcdir/summer-day-and-night-main/waybar/"* "$pkgdir/etc/skel/.config/waybar/"
  cp -r "$srcdir/summer-day-and-night-main/wofi/"* "$pkgdir/etc/skel/.config/wofi/"
  cp -r "$srcdir/summer-day-and-night-main/kitty/"* "$pkgdir/etc/skel/.config/kitty/"
  
  # Make scripts executable
  find "$pkgdir" -name "*.sh" -exec chmod +x {} \;
  find "$pkgdir" -name "*.py" -exec chmod +x {} \;
  
  # Create a README file with installation instructions
  mkdir -p "$pkgdir/usr/share/doc/$pkgname"
  cat > "$pkgdir/usr/share/doc/$pkgname/README.md" << EOL
# Summer Day and Night Theme

This package installs the Summer Day and Night theme for Hyprland.

## Usage

The configuration files have been installed to your home directory.
To switch between day and night themes, use Super+Shift+T.

## Dependencies

All required dependencies have been installed automatically.
Optional dependencies can be installed separately.

## Credits

Wallpapers and theme created by the original author.
EOL
}
EOF

cat > summer-day-and-night-theme.install << 'EOF'
post_install() {
  echo "==> Summer Day and Night Theme has been installed!"
  echo "    Configuration files are available in /usr/share/summer-day-and-night-theme"
  echo "    To use this theme, copy the configuration files to your home directory:"
  echo "    cp -r /etc/skel/.config/hypr ~/.config/"
  echo "    cp -r /etc/skel/.config/waybar ~/.config/"
  echo "    cp -r /etc/skel/.config/wofi ~/.config/"
  echo "    cp -r /etc/skel/.config/kitty ~/.config/"
  echo ""
  echo "    To switch between day and night themes, use Super+Shift+T"
  echo ""
  echo "    Note: For the 3D border effect mentioned in the README,"
  echo "    you may need to modify your Hyprland source code as described"
  echo "    in /usr/share/summer-day-and-night-theme/README.md"
}

post_upgrade() {
  post_install
}
EOF

# Copy the zip file to the current directory and rename it
echo "Copying the theme files..."
cp "$1" "summer-day-and-night-theme-1.0.0.zip"

# Build the package
echo "Building the package..."
echo "Note: This package requires AUR helpers to install git packages like waybar-git, kitty-git, etc."
echo "Make sure you have an AUR helper like yay or paru installed."

# Check if yay is installed
if command -v yay &> /dev/null; then
    echo "Using yay to build and install the package..."
    makepkg -si
elif command -v paru &> /dev/null; then
    echo "Using paru to build and install the package..."
    makepkg -si
else
    echo "Warning: No AUR helper found. You may need to install the AUR dependencies manually."
    echo "Would you like to continue with makepkg? (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        makepkg -si
    else
        echo "Installation aborted."
        exit 1
    fi
fi

# Clean up
echo "Cleaning up..."
cd ..
rm -rf "$TEMP_DIR"

echo ""
echo "=== Installation Complete! ==="
echo "The Summer Day and Night theme has been installed on your system."
echo "To apply the theme, follow the post-installation instructions."
