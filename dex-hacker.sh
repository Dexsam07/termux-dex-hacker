#!/data/data/com.termux/files/usr/bin/bash

# ==========================================================
# DEX-HACKER Ultimate Termux Environment
# Developer: Dex Shyam Tech | Instagram: @dex_shyam_42
# GitHub: https://github.com/Dexsam07/termux-dex-hacker
# ==========================================================

set -e

# Colors for output
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Directories & files
DEX_DIR="$HOME/.dex_hacker"
PASSWORD_FILE="$DEX_DIR/password.txt"
CONFIG_FILE="$DEX_DIR/config.cfg"
LOG_FILE="$DEX_DIR/setup.log"
FLAG_FILE="$DEX_DIR/installed.flag"

# Function to log messages
log() {
    echo -e "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Function to install necessary packages
install_packages() {
    echo -e "${CYAN}[+] Updating packages and installing required tools...${NC}"
    pkg update -y && pkg upgrade -y
    pkg install -y mpv yt-dlp termux-api nano git curl wget
    log "Packages installed: mpv, yt-dlp, termux-api, nano, git, curl, wget"
}

# First time setup
if [ ! -f "$FLAG_FILE" ]; then
    echo -e "${RED}╔════════════════════════════════════════╗${NC}"
    echo -e "${RED}║      DEX-HACKER FIRST TIME SETUP       ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════╝${NC}"
    echo ""

    mkdir -p "$DEX_DIR"
    install_packages

    # Set a password (stored in plain text as requested)
    echo -e "${YELLOW}[!] Set a password for protected actions (you can view it later with 'nano $PASSWORD_FILE'):${NC}"
    read -s -p "Enter password: " user_pass
    echo ""
    read -s -p "Confirm password: " user_pass2
    echo ""
    if [ "$user_pass" != "$user_pass2" ]; then
        echo -e "${RED}Passwords do not match. Exiting.${NC}"
        exit 1
    fi
    echo "$user_pass" > "$PASSWORD_FILE"
    chmod 600 "$PASSWORD_FILE"
    log "Password created and stored in $PASSWORD_FILE"

    # Create default config
    cat > "$CONFIG_FILE" <<EOF
# DEX-HACKER Configuration
LOADING_STYLE="matrix"
AUTO_PLAY_MP3="yes"
PROMPT_COLOR="cyan"
EOF

    # Create a custom bashrc that will run every time Termux starts
    # Backup original bashrc if exists
    if [ -f "$HOME/.bashrc" ]; then
        cp "$HOME/.bashrc" "$HOME/.bashrc.dex_backup"
        log "Original .bashrc backed up to .bashrc.dex_backup"
    fi

    cat > "$HOME/.bashrc" <<'BASHRC_EOF'
# ==========================================================
# DEX-HACKER Environment - Auto-loaded by Termux
# Developer: Dex Shyam Tech | Instagram: @dex_shyam_42
# ==========================================================

# Source the DEX-HACKER main script
if [ -f "$HOME/.dex_hacker/main.sh" ]; then
    source "$HOME/.dex_hacker/main.sh"
fi
BASHRC_EOF

    # Create the main DEX-HACKER runtime script
    cat > "$DEX_DIR/main.sh" <<'MAIN_EOF'
#!/data/data/com.termux/files/usr/bin/bash

# ----------------------------------------------------------
# DEX-HACKER CORE RUNTIME
# ----------------------------------------------------------

DEX_DIR="$HOME/.dex_hacker"
PASSWORD_FILE="$DEX_DIR/password.txt"
CONFIG_FILE="$DEX_DIR/config.cfg"
RED='\033[1;31m'; GREEN='\033[1;32m'; YELLOW='\033[1;33m'
BLUE='\033[1;34m'; PURPLE='\033[1;35m'; CYAN='\033[1;36m'
WHITE='\033[1;37m'; NC='\033[0m'

# Load config
source "$CONFIG_FILE" 2>/dev/null || true

# -------------------- Helper Functions --------------------
play_mp3_loading() {
    if [ "$AUTO_PLAY_MP3" = "yes" ]; then
        mpv --no-video --volume=60 "https://files.catbox.moe/e4fmn4.mp3" > /dev/null 2>&1 &
        MPV_PID=$!
    fi
}

stop_mp3() {
    kill $MPV_PID 2>/dev/null || pkill mpv 2>/dev/null
}

matrix_loading() {
    clear
    echo -e "${GREEN}╔════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║     🧨 DEX-HACKER LINUX SYSTEM LOADING 🧨      ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════╝${NC}"
    echo ""
    for i in {1..20}; do
        echo -ne "${CYAN}["
        for j in $(seq 1 $i); do echo -ne "█"; done
        for j in $(seq $((i+1)) 20); do echo -ne "░"; done
        echo -ne "] $((i*5))% \r"
        sleep 0.25
    done
    echo -e "\n${GREEN}[✔] SYSTEM READY in 5 seconds!${NC}"
    sleep 1
}

hacker_banner() {
    clear
    echo -e "${RED}   ____  _____   __   _   _   __  __   ____   _   _   ____   _____  ${NC}"
    echo -e "${RED}  |  _ \\|  ___| |  \\ | | | | | |  \\/  | |  _ \\ | | | | / ___| |_   _| ${NC}"
    echo -e "${RED}  | | | | |_    | |\\ \\| | | | | | |\\/| | | |_) || | | | \\___ \\   | |   ${NC}"
    echo -e "${RED}  | |_| |  _|   | | \\ \\ | | | | | |  | | |  _ < | |_| |  ___) |  | |   ${NC}"
    echo -e "${RED}  |____/|_|     |_|  \\__| |_| |_|  |_| |_| \\_\\ \\____/ |____/   |_|   ${NC}"
    echo -e "${WHITE}              ⚡ DEVELOPER: DEX SHYAM TECH ⚡${NC}"
    echo -e "${CYAN}          🔒 INSTAGRAM: @dex_shyam_42 (UNCHANGEABLE) 🔒${NC}"
    echo -e "${PURPLE}--------------------------------------------------------${NC}"
}

# -------------------- Core Commands --------------------
ytplay() {
    if [ -z "$1" ]; then
        echo -e "${RED}Usage: ytplay \"song name or YouTube URL\"${NC}"
        return 1
    fi
    echo -e "${GREEN}[+] Searching and playing: $1${NC}"
    yt-dlp -f bestaudio --no-playlist -o - "ytsearch1:$1" | mpv --no-video -
}

dex_support() {
    echo -e "${YELLOW}💬 Developer Support Menu 💬${NC}"
    echo -ne "Do you need support from Dex Shyam Tech? (yes/no): "
    read answer
    if [[ "$answer" == "yes" || "$answer" == "y" ]]; then
        echo -e "${GREEN}✅ Developer will assist you! Contact:${NC}"
        echo -e "   📧 Instagram: @dex_shyam_42"
        echo -e "   🐙 GitHub: https://github.com/Dexsam07"
        echo -e "${CYAN}Support is always free. Keep hacking!${NC}"
    else
        echo -e "${RED}❌ You cut the developer's job! Restart Termux to restore this option.${NC}"
        # Fun: disable support option until restart
        alias dex_support="echo 'Developer fired! Restart Termux to hire again.'"
    fi
}

dex_password() {
    echo -ne "${YELLOW}Enter current password to change it: ${NC}"
    read -s cur_pass
    echo ""
    if [ "$cur_pass" = "$(cat $PASSWORD_FILE)" ]; then
        echo -ne "${CYAN}New password: ${NC}"
        read -s new_pass1
        echo ""
        echo -ne "${CYAN}Confirm new password: ${NC}"
        read -s new_pass2
        echo ""
        if [ "$new_pass1" = "$new_pass2" ]; then
            echo "$new_pass1" > "$PASSWORD_FILE"
            echo -e "${GREEN}Password changed successfully!${NC}"
        else
            echo -e "${RED}Mismatch. Aborted.${NC}"
        fi
    else
        echo -e "${RED}Wrong password!${NC}"
    fi
}

dex_config() {
    echo -e "${BLUE}⚙️  DEX-HACKER Configuration ⚙️${NC}"
    echo "1) Toggle MP3 auto-play on startup (current: $AUTO_PLAY_MP3)"
    echo "2) Change prompt color"
    echo "3) Reset all to default"
    echo -n "Choose [1-3]: "
    read opt
    case $opt in
        1)
            if [ "$AUTO_PLAY_MP3" = "yes" ]; then
                sed -i 's/AUTO_PLAY_MP3="yes"/AUTO_PLAY_MP3="no"/' "$CONFIG_FILE"
                echo -e "${GREEN}Auto-play disabled.${NC}"
            else
                sed -i 's/AUTO_PLAY_MP3="no"/AUTO_PLAY_MP3="yes"/' "$CONFIG_FILE"
                echo -e "${GREEN}Auto-play enabled.${NC}"
            fi
            ;;
        2)
            echo -e "${CYAN}Available colors: red, green, yellow, blue, purple, cyan, white${NC}"
            read -p "Enter new prompt color: " col
            sed -i "s/PROMPT_COLOR=\".*\"/PROMPT_COLOR=\"$col\"/" "$CONFIG_FILE"
            ;;
        3)
            sed -i 's/LOADING_STYLE=".*"/LOADING_STYLE="matrix"/' "$CONFIG_FILE"
            sed -i 's/AUTO_PLAY_MP3=".*"/AUTO_PLAY_MP3="yes"/' "$CONFIG_FILE"
            sed -i 's/PROMPT_COLOR=".*"/PROMPT_COLOR="cyan"/' "$CONFIG_FILE"
            echo -e "${GREEN}Reset to defaults done.${NC}"
            ;;
        *) echo -e "${RED}Invalid option${NC}" ;;
    esac
    source "$CONFIG_FILE"
}

# Social media links
show_socials() {
    echo -e "${PURPLE}📱 Connect with Developer & Get Support 📱${NC}"
    echo -e "   🔹 Instagram : ${CYAN}@dex_shyam_42${NC}"
    echo -e "   🔹 GitHub    : ${CYAN}https://github.com/Dexsam07${NC}"
    echo -e "   🔹 Project   : ${CYAN}termux-dex-hacker${NC}"
    echo -e "${YELLOW}💥 If you like this tool, give a star on GitHub! 💥${NC}"
}

# -------------------- Startup Procedure --------------------
# Disable default Termux welcome message
touch "$HOME/.hushlogin"

# Play the MP3 and show loading (5 seconds)
play_mp3_loading
matrix_loading
stop_mp3

# Show final banner
hacker_banner

# Custom prompt with real-time clock and brand
set_prompt() {
    local color_code=""
    case $PROMPT_COLOR in
        red) color_code="31";; green) color_code="32";; yellow) color_code="33";;
        blue) color_code="34";; purple) color_code="35";; cyan) color_code="36";;
        white) color_code="37";; *) color_code="36";;
    esac
    PS1="\[\033[1;${color_code}m\]┌──(DEX-HACKER@\h:\[\033[0m\]\[\033[1;34m\]\w\[\033[0m\]\[\033[1;${color_code}m\])\n└─[\[\033[1;33m\]\A\[\033[0m\]\[\033[1;${color_code}m\]]\$ \[\033[0m\]"
}
set_prompt

# Aliases
alias ytplay='ytplay'
alias dex-help='echo -e "Commands: ytplay, dex_support, dex_password, dex_config, show_socials"'
alias dex-social='show_socials'

# Final message
echo -e "${GREEN}✅ System ready! Type 'dex-help' for available commands.${NC}"
echo -e "${CYAN}🔊 Song finished loading. You can now run any Linux command.${NC}"

MAIN_EOF

    chmod +x "$DEX_DIR/main.sh"
    touch "$FLAG_FILE"
    log "DEX-HACKER installation completed successfully."

    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  INSTALLATION FINISHED!                ║${NC}"
    echo -e "${GREEN}║  Restart Termux to enter DEX-HACKER    ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Your password is stored at: $PASSWORD_FILE"
    echo -e "If you forget it, run: nano $PASSWORD_FILE${NC}"
    echo -e "${BLUE}Now close Termux and open it again to experience the magic!${NC}"
else
    echo -e "${RED}DEX-HACKER is already installed!${NC}"
    echo -e "Just restart Termux to use it. Or run 'bash $0' if you need to reinstall."
fi
