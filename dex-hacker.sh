#!/data/data/com.termux/files/usr/bin/bash
# ============================================
# DEX-HACKER Ultimate Termux Environment
# Author: Dex Shyam Tech | @dex_shyam_42
# GitHub: https://github.com/Dexsam07/termux-dex-hacker
# ============================================

set -e

# --- Directories & files ---
DEX_DIR="$HOME/.dex_hacker"
PASSWD_FILE="$DEX_DIR/.passwd"
CONFIG_FILE="$DEX_DIR/config"
FLAG_FILE="$DEX_DIR/played"
MAIN_SCRIPT="$PREFIX/bin/dex-hacker"
CUSTOM_MP3_URL="https://files.catbox.moe/e4fmn4.mp3"

# --- Colors (for dangerous look) ---
RED='\033[1;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m'

# --- Banner ASCII (smaller for phone) ---
banner() {
    echo -e "${RED}"
    echo "██████╗ ███████╗██╗  ██╗     ██╗  ██╗ █████╗  ██████╗██╗  ██╗███████╗██████╗ "
    echo "██╔══██╗██╔════╝╚██╗██╔╝     ██║  ██║██╔══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗"
    echo "██║  ██║█████╗   ╚███╔╝█████╗███████║███████║██║     █████╔╝ █████╗  ██████╔╝"
    echo "██║  ██║██╔══╝   ██╔██╗╚════╝██╔══██║██╔══██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗"
    echo "██████╔╝███████╗██╔╝ ██╗     ██║  ██║██║  ██║╚██████╗██║  ██╗███████╗██║  ██║"
    echo "╚═════╝ ╚══════╝╚═╝  ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝"
    echo -e "${NC}"
    echo -e "${CYAN}         ⚡ DEX-HACKER v1.0 | @dex_shyam_42 ⚡${NC}"
}

# --- Setup function (runs only once) ---
setup() {
    echo -e "${YELLOW}[*] First run detected. Setting up DEX-HACKER environment...${NC}"
    mkdir -p "$DEX_DIR"
    
    # Install required packages
    pkg update -y && pkg upgrade -y
    pkg install mpv yt-dlp ffmpeg termux-api nano git -y
    
    # Storage permission
    termux-setup-storage 2>/dev/null || true
    
    # Set password
    if [[ ! -f "$PASSWD_FILE" ]]; then
        echo -e "${RED}Set your master password (used for dex-lock):${NC}"
        read -s user_pass
        echo "$user_pass" > "$PASSWD_FILE"
        echo -e "${GREEN}[+] Password stored in $PASSWD_FILE (you can nano it later)${NC}"
    fi
    
    # Default config
    cat > "$CONFIG_FILE" <<EOF
NAME="User"
COLOR="$RED"
SUPPORT="yes"
LAST_SUPPORT_CHECK=$(date +%s)
EOF
    
    # Disable default Termux welcome message
    touch "$HOME/.hushlogin"
    # Also clear motd if exists
    if [[ -f "$PREFIX/etc/motd" ]]; then
        mv "$PREFIX/etc/motd" "$PREFIX/etc/motd.bak"
    fi
    
    # Create main script that will be sourced in .bashrc
    cat > "$MAIN_SCRIPT" <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash
# DEX-HACKER core script – sourced at every shell start

DEX_DIR="$HOME/.dex_hacker"
PASSWD_FILE="$DEX_DIR/.passwd"
CONFIG_FILE="$DEX_DIR/config"
FLAG_FILE="$DEX_DIR/played"
CUSTOM_MP3_URL="https://files.catbox.moe/e4fmn4.mp3"

source "$CONFIG_FILE"

# --- Check support expiry ---
check_support() {
    if [[ "$SUPPORT" == "no" ]]; then
        current=$(date +%s)
        last=$LAST_SUPPORT_CHECK
        diff=$(( (current - last) / 86400 ))
        if [[ $diff -ge 3 ]]; then
            echo -e "\033[1;31m[!] Support disabled for 3 days. This script is now LOCKED.\033[0m"
            echo "Contact @dex_shyam_42 on Instagram to reactivate."
            exit 1
        fi
    fi
}

# --- Play the custom MP3 once per session ---
play_mp3_once() {
    if [[ -z "$DEX_HACKER_PLAYED" ]]; then
        export DEX_HACKER_PLAYED=1
        (mpv --no-video --volume=70 "$CUSTOM_MP3_URL" >/dev/null 2>&1 &)
    fi
}

# --- Hacking loading animation (5 seconds) ---
loading() {
    echo -e "\033[1;32m[+] Loading DEX-HACKER kernel modules...\033[0m"
    for i in {1..5}; do
        echo -ne "\033[1;33m[===      ] $((i*20))% Hack the planet...\r\033[0m"
        sleep 1
    done
    echo -e "\n\033[1;32m[✔] System ready.\033[0m"
}

# --- Real-time prompt with clock (updated every second) ---
prompt_command() {
    PS1="\[\033[1;31m\]DEX-HACKER\[\033[0m\]@\[\033[1;36m\]\t\[\033[0m\] \[\033[1;33m\]\w\[\033[0m\] \$ "
}
PROMPT_COMMAND=prompt_command

# --- Custom tools ---
playsong() {
    [[ -z "$1" ]] && echo "Usage: playsong \"song name\"" && return 1
    yt-dlp --no-check-certificate -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 -o "temp_song.%(ext)s" "ytsearch1:$1"
    mpv --no-video temp_song.*
    rm temp_song.*
}

playmp3() {
    mpv --no-video "$CUSTOM_MP3_URL"
}

dex-lock() {
    echo -e "\033[1;31m[!] Terminal locked. Enter password to unlock:\033[0m"
    read -s input_pass
    stored_pass=$(cat "$PASSWD_FILE")
    if [[ "$input_pass" == "$stored_pass" ]]; then
        echo -e "\033[1;32m[✔] Unlocked.\033[0m"
    else
        echo -e "\033[1;31m[✘] Wrong password. Exiting.\033[0m"
        exit 1
    fi
}

dex-support() {
    current_support=$(grep SUPPORT "$CONFIG_FILE" | cut -d'=' -f2 | tr -d '"')
    if [[ "$current_support" == "yes" ]]; then
        sed -i 's/SUPPORT="yes"/SUPPORT="no"/' "$CONFIG_FILE"
        echo -e "\033[1;33mSupport disabled. You have 3 days before script locks.\033[0m"
    else
        sed -i 's/SUPPORT="no"/SUPPORT="yes"/' "$CONFIG_FILE"
        # reset last check
        sed -i "s/LAST_SUPPORT_CHECK=.*/LAST_SUPPORT_CHECK=$(date +%s)/" "$CONFIG_FILE"
        echo -e "\033[1;32mSupport enabled. Thanks!\033[0m"
    fi
    source "$CONFIG_FILE"
}

dex-storage() {
    echo -e "\033[1;36m==== Storage Info ====\033[0m"
    df -h /data/data/com.termux/files/home
    echo -e "\n\033[1;36mInternal shared storage:\033[0m"
    if [[ -d ~/storage/shared ]]; then
        df -h ~/storage/shared
    else
        echo "Run 'termux-setup-storage' first."
    fi
}

dex-run() {
    file="$1"
    [[ -z "$file" ]] && echo "Usage: dex-run <filename>" && return 1
    if [[ ! -f "$file" ]]; then
        echo "File not found."
        return 1
    fi
    ext="${file##*.}"
    case "$ext" in
        py) python3 "$file" ;;
        html) termux-open "$file" ;;
        js) node "$file" 2>/dev/null || echo "Install nodejs: pkg install nodejs" ;;
        sh) bash "$file" ;;
        *) echo "Unsupported extension." ;;
    esac
}

dex-passwd() {
    echo -e "\033[1;33mEnter NEW master password:\033[0m"
    read -s newpass
    echo "$newpass" > "$PASSWD_FILE"
    echo -e "\033[1;32mPassword updated.\033[0m"
}

dex-update() {
    cd "$HOME/termux-dex-hacker" 2>/dev/null || { echo "Repo not found at ~/termux-dex-hacker"; return 1; }
    git pull
    ./install.sh
    echo "Update done. Restart Termux."
}

# --- Export functions so they are available in shell ---
export -f playsong playmp3 dex-lock dex-support dex-storage dex-run dex-passwd dex-update

# --- Main startup sequence (only for interactive login) ---
if [[ $- == *i* ]]; then
    check_support
    banner
    loading
    play_mp3_once
fi
EOF

    chmod +x "$MAIN_SCRIPT"
    
    # Add sourcing to .bashrc (idempotent)
    if ! grep -q "source $MAIN_SCRIPT" "$HOME/.bashrc"; then
        echo "source $MAIN_SCRIPT" >> "$HOME/.bashrc"
    fi
    
    echo -e "${GREEN}[✔] Setup complete! Restart Termux or run 'source ~/.bashrc'${NC}"
}

# --- If first run, call setup ---
if [[ ! -d "$DEX_DIR" ]]; then
    setup
else
    # Normal execution when script is sourced? Actually we just source the main script in .bashrc.
    # But this install script is only run once.
    echo -e "${CYAN}DEX-HACKER already installed. Run 'dex-update' to update.${NC}"
fi
