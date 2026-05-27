#!/data/data/com.termux/files/usr/bin/bash
# DEX-HACKER Termux Installer - One time setup

echo "[*] Installing DEX-HACKER environment..."

# Update & install essential packages
pkg update -y && pkg upgrade -y
pkg install -y mpv yt-dlp python nodejs curl wget git nano

# Create directory structure
DEX_HOME="$HOME/.dex_hacker"
mkdir -p "$DEX_HOME"/{www,logs,bin}
mkdir -p "$HOME/storage"   # ensure storage access (will prompt)

# Give storage permission
termux-setup-storage

# Download the main script
curl -o "$DEX_HOME/bin/dex-hacker.sh" "https://raw.githubusercontent.com/Dexsam07/termux-dex-hacker/main/dex-hacker.sh"
chmod +x "$DEX_HOME/bin/dex-hacker.sh"

# Add to .bashrc (autostart)
if ! grep -q "dex-hacker.sh" "$HOME/.bashrc"; then
    echo -e "\n# DEX-HACKER autostart\nbash $DEX_HOME/bin/dex-hacker.sh\n" >> "$HOME/.bashrc"
fi

# Set default password (change it later)
echo "dex@123" > "$DEX_HOME/.password"

# Create dummy web root
echo "<h1>🔥 DEX-HACKER Local Server 🔥</h1><p>Upload your HTML/CSS/JS here: $DEX_HOME/www/</p>" > "$DEX_HOME/www/index.html"

echo "[✓] Installation complete! Restart Termux or run 'bash $DEX_HOME/bin/dex-hacker.sh'"
