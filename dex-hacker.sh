#!/data/data/com.termux/files/usr/bin/bash

# ----------------------------------------------
# Termux DEX-HACKER Environment Setup Script
# Author: Dex Shyam Tech (Dexsam07)
# Repo: https://github.com/Dexsam07/termux-dex-hacker
# ----------------------------------------------

set -e  # exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║    DEX-HACKER Termux Environment      ║${NC}"
echo -e "${CYAN}║         by Dex Shyam Tech             ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"

# 1. Update packages and install dependencies
echo -e "${YELLOW}[*] Updating Termux packages...${NC}"
pkg update -y && pkg upgrade -y

echo -e "${YELLOW}[*] Installing required tools...${NC}"
pkg install -y mpv yt-dlp python nodejs nano curl wget git termux-api

# 2. Setup storage access
echo -e "${YELLOW}[*] Granting storage access...${NC}"
termux-setup-storage

# 3. Create DEX-HACKER configuration directory
HACKER_DIR="$HOME/.dex_hacker"
mkdir -p "$HACKER_DIR"

# 4. Set password (first time)
if [ ! -f "$HACKER_DIR/pass.txt" ]; then
    echo -e "${YELLOW}[!] First time setup. Set your Termux password:${NC}"
    read -s -p "Enter new password: " USER_PASS
    echo
    read -s -p "Confirm password: " USER_PASS2
    echo
    if [ "$USER_PASS" = "$USER_PASS2" ]; then
        echo "$USER_PASS" > "$HACKER_DIR/pass.txt"
        echo -e "${GREEN}[+] Password saved. (Recovery: nano ~/.dex_hacker/pass.txt)${NC}"
    else
        echo -e "${RED}[!] Passwords do not match. Exiting.${NC}"
        exit 1
    fi
fi

# 5. Create the startup script that runs every time Termux opens
STARTUP_SCRIPT="$HACKER_DIR/startup.sh"
cat > "$STARTUP_SCRIPT" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash

HACKER_DIR="$HOME/.dex_hacker"
PASS_FILE="$HACKER_DIR/pass.txt"
SUPPORT_FILE="$HACKER_DIR/support.txt"
SONG_URL="https://files.catbox.moe/e4fmn4.mp3"

# Password prompt
echo -n "🔐 Enter your DEX-HACKER password: "
read -s USER_INPUT
echo
STORED_PASS=$(cat "$PASS_FILE")
if [ "$USER_INPUT" != "$STORED_PASS" ]; then
    echo -e "\033[0;31m[!] Access denied. Wrong password.\033[0m"
    exit 1
fi

# Check support status
if [ -f "$SUPPORT_FILE" ]; then
    SUPPORT=$(cat "$SUPPORT_FILE")
    if [ "$SUPPORT" = "no" ]; then
        echo -e "\033[0;31m[!] Developer support is disabled. Access blocked.\033[0m"
        echo "Contact @dex_shyam_42 on Instagram to re-enable."
        exit 1
    fi
else
    echo "yes" > "$SUPPORT_FILE"
fi

# Clear screen for loading animation
clear

# Show ASCII art & loading (5 seconds)
echo -e "\033[0;36m"
cat << "BANNER"
██████╗ ███████╗██╗  ██╗     ██╗  ██╗ █████╗  ██████╗██╗  ██╗███████╗██████╗ 
██╔══██╗██╔════╝╚██╗██╔╝     ██║  ██║██╔══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗
██║  ██║█████╗   ╚███╔╝█████╗███████║███████║██║     █████╔╝ █████╗  ██████╔╝
██║  ██║██╔══╝   ██╔██╗╚════╝██╔══██║██╔══██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗
██████╔╝███████╗██╔╝ ██╗     ██║  ██║██║  ██║╚██████╗██║  ██╗███████╗██║  ██║
╚═════╝ ╚══════╝╚═╝  ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
BANNER
echo -e "\033[0;33mDeveloper: Dex Shyam Tech | Instagram: @dex_shyam_42${NC}"
echo -e "\033[0;32mLoading Linux kernel modules...\033[0m"
for i in {1..5}; do
    echo -n "█"
    sleep 0.5
done
echo -e "\n\033[0;32mSystem ready. Welcome, hacker.\033[0m"

# Play startup song in background (mpv)
mpv --no-video --really-quiet "$SONG_URL" > /dev/null 2>&1 &

# Custom prompt with real-time clock and branding
PROMPT_CMD='PS1="\[\033[0;36m\]DEX-HACKER\[\033[0m\]@\[\033[0;32m\]\h\[\033[0m\]:\[\033[0;33m\]\t\[\033[0m\]\$ "'
echo "$PROMPT_CMD" >> "$HOME/.bashrc_temp"
# Apply prompt immediately
eval "$PROMPT_CMD"

# Define useful functions/aliases
alias dex-menu='source $HOME/.dex_hacker/menu.sh'
alias play-song='$HOME/.dex_hacker/play_song.sh'
alias run-html='$HOME/.dex_hacker/run_html.sh'
alias run-js='$HOME/.dex_hacker/run_js.sh'
alias run-py='python3'
alias net-speed='$HOME/.dex_hacker/net_speed.sh'
alias support='$HOME/.dex_hacker/toggle_support.sh'
alias change-pass='$HOME/.dex_hacker/change_pass.sh'
alias daily='$HOME/.dex_hacker/daily_tip.sh'

echo -e "\033[0;32m[+] Type 'dex-menu' to open the hacker tool suite.\033[0m"
EOF

# 6. Create tool scripts
# play_song.sh (YouTube audio search)
cat > "$HACKER_DIR/play_song.sh" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
if [ -z "$1" ]; then
    echo "Usage: play-song \"song name\""
    exit 1
fi
echo "Searching and playing: $1"
yt-dlp -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 -o "temp_song.%(ext)s" "ytsearch1:$1" > /dev/null 2>&1
mpv --no-video "temp_song.mp3"
rm temp_song.mp3
EOF

# net_speed.sh (simple network monitor)
cat > "$HACKER_DIR/net_speed.sh" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
INTERFACE="wlan0"  # change to your if needed
RX_BEFORE=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
TX_BEFORE=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)
sleep 1
RX_AFTER=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
TX_AFTER=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)
RX_RATE=$(( ($RX_AFTER - $RX_BEFORE) / 1024 ))
TX_RATE=$(( ($TX_AFTER - $TX_BEFORE) / 1024 ))
echo "⬇️ Download: $RX_RATE KB/s"
echo "⬆️ Upload:   $TX_RATE KB/s"
EOF

# run_html.sh
cat > "$HACKER_DIR/run_html.sh" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
if [ -z "$1" ]; then
    echo "Usage: run-html file.html"
    exit 1
fi
termux-open "$1"
EOF

# run_js.sh (requires nodejs)
cat > "$HACKER_DIR/run_js.sh" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
if [ -z "$1" ]; then
    echo "Usage: run-js file.js"
    exit 1
fi
node "$1"
EOF

# toggle_support.sh
cat > "$HACKER_DIR/toggle_support.sh" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
SUPPORT_FILE="$HOME/.dex_hacker/support.txt"
CURRENT=$(cat "$SUPPORT_FILE")
if [ "$CURRENT" = "yes" ]; then
    echo "no" > "$SUPPORT_FILE"
    echo "⚠️ Developer support disabled. You will be locked out next login."
else
    echo "yes" > "$SUPPORT_FILE"
    echo "✅ Developer support enabled."
fi
EOF

# change_pass.sh
cat > "$HACKER_DIR/change_pass.sh" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
echo "Change your DEX-HACKER password"
read -s -p "New password: " NEW
echo
read -s -p "Confirm: " CONFIRM
echo
if [ "$NEW" = "$CONFIRM" ]; then
    echo "$NEW" > "$HOME/.dex_hacker/pass.txt"
    echo "Password changed."
else
    echo "Mismatch."
fi
EOF

# daily_tip.sh
cat > "$HACKER_DIR/daily_tip.sh" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
TIPS=("Use 'dex-menu' for tools" "Play YouTube audio with 'play-song'" "Run HTML files with 'run-html'" "Support @dex_shyam_42 on Instagram")
RANDOM_INDEX=$(( RANDOM % ${#TIPS[@]} ))
echo "💡 Tip: ${TIPS[$RANDOM_INDEX]}"
EOF

# 7. Main menu script (includes AI tools, HTML/JS runner, network)
cat > "$HACKER_DIR/menu.sh" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
while true; do
    clear
    echo -e "\033[0;36m═══════════════════════════════════════════════════\033[0m"
    echo -e "          \033[1;33mDEX-HACKER MAIN TOOL MENU\033[0m"
    echo -e "\033[0;36m═══════════════════════════════════════════════════\033[0m"
    echo "1. 🎵 Play YouTube song (no ads)"
    echo "2. 🌐 Open Free AI Tools (Browser)"
    echo "3. 📄 Run HTML file"
    echo "4. 📜 Run JavaScript file"
    echo "5. 🐍 Run Python script"
    echo "6. 📡 Check network speed"
    echo "7. ❤️ Developer support (toggle yes/no)"
    echo "8. 🔑 Change password"
    echo "9. 💡 Daily hacking tip"
    echo "10. 🚪 Exit menu"
    echo -e "\033[0;36m═══════════════════════════════════════════════════\033[0m"
    read -p "Choose [1-10]: " choice
    case $choice in
        1) read -p "Song name: " song; play-song "$song" ;;
        2) echo "Opening free AI tools..."; termux-open-url "https://chat.openai.com"; termux-open-url "https://claude.ai"; termux-open-url "https://gemini.google.com" ;;
        3) read -p "HTML file path: " htmlf; run-html "$htmlf" ;;
        4) read -p "JS file path: " jsf; run-js "$jsf" ;;
        5) read -p "Python script: " pyf; python3 "$pyf" ;;
        6) net-speed ;;
        7) support ;;
        8) change-pass ;;
        9) daily ;;
        10) break ;;
        *) echo "Invalid"; sleep 1 ;;
    esac
    read -p "Press Enter to continue..."
done
EOF

# Make all scripts executable
chmod +x "$HACKER_DIR"/*.sh
chmod +x "$STARTUP_SCRIPT"

# 8. Modify .bashrc to run the startup script on each login
BASHRC="$HOME/.bashrc"
if ! grep -q "dex_hacker/startup.sh" "$BASHRC" 2>/dev/null; then
    echo -e "\n# DEX-HACKER environment\nsource \$HOME/.dex_hacker/startup.sh" >> "$BASHRC"
fi

# 9. Remove default Termux welcome message (optional)
if [ -f "$PREFIX/etc/motd" ]; then
    mv "$PREFIX/etc/motd" "$PREFIX/etc/motd.bak"
fi

# 10. Final message
echo -e "${GREEN}════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ Installation complete!${NC}"
echo -e "${GREEN}Close Termux completely and reopen to experience DEX-HACKER.${NC}"
echo -e "${YELLOW}Your password is stored at ~/.dex_hacker/pass.txt (nano to recover).${NC}"
echo -e "${CYAN}Instagram: @dex_shyam_42 | Repo: https://github.com/Dexsam07/termux-dex-hacker${NC}"
