#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# TERMUX DEX-HACKER - Advanced Terminal Suite
# Developer : Dex Shyam Tech
# Instagram : @dex_shyam_42 (Hardcoded - Immutable)
# GitHub    : https://github.com/Dexsam07/termux-dex-hacker
# ============================================================

# ---------- GLOBAL CONFIG ----------
SCRIPT_DIR="$HOME/.dexhacker"
CONFIG_FILE="$SCRIPT_DIR/config.cfg"
PASSWD_FILE="$SCRIPT_DIR/password"
FIRST_RUN_FLAG="$SCRIPT_DIR/first_run_done"
INTRO_SONG_URL="https://files.catbox.moe/e4fmn4.mp3"

# ---------- CREATE DIRS & DEFAULTS ----------
mkdir -p "$SCRIPT_DIR"

if [[ ! -f "$CONFIG_FILE" ]]; then
    cat > "$CONFIG_FILE" <<EOF
USER_NAME="Hacker"
COLOR_CYAN="\033[1;36m"
COLOR_RED="\033[1;31m"
COLOR_GREEN="\033[1;32m"
COLOR_YELLOW="\033[1;33m"
COLOR_RESET="\033[0m"
AUTO_PLAY_SONG="yes"
EOF
fi

source "$CONFIG_FILE"

# ---------- UTILITY FUNCTIONS ----------
print_banner() {
    echo -e "${COLOR_RED}"
    echo " ⚡ DEX-HACKER TERMINAL v1.0 ⚡"
    echo -e "${COLOR_CYAN} Developer : Dex Shyam Tech"
    echo -e " IG       : @dex_shyam_42 (Immutable)"
    echo -e " GitHub   : https://github.com/Dexsam07/termux-dex-hacker${COLOR_RESET}"
    echo "=============================================="
}

real_time_header() {
    clear
    print_banner
    echo -e "${COLOR_GREEN}┌─[ DEX-HACKER @ $(date +'%H:%M:%S') ]──────────────────┐${COLOR_RESET}"
    echo -e "${COLOR_YELLOW}│ System : $(uname -o)  |  User : $USER_NAME${COLOR_RESET}"
    echo -e "${COLOR_YELLOW}│ Storage: $(df -h /data/data/com.termux/files/home 2>/dev/null | awk 'NR==2 {print $4}') free / $(df -h /data/data/com.termux/files/home 2>/dev/null | awk 'NR==2 {print $2}') total${COLOR_RESET}"
    echo -e "${COLOR_GREEN}└────────────────────────────────────────────────────┘${COLOR_RESET}"
}

play_song_background() {
    if [[ "$AUTO_PLAY_SONG" == "yes" ]]; then
        if command -v mpv &>/dev/null; then
            mpv --no-video --really-quiet "$INTRO_SONG_URL" &>/dev/null &
            disown
        else
            echo -e "${COLOR_RED}[!] mpv not installed. Song cannot play.${COLOR_RESET}"
            sleep 1
        fi
    fi
}

# ---------- PASSWORD HANDLING ----------
setup_password() {
    if [[ ! -f "$PASSWD_FILE" ]]; then
        echo -e "${COLOR_YELLOW}[!] First time setup - Create a password for the system${COLOR_RESET}"
        read -s -p "Enter new password: " pass
        echo
        read -s -p "Confirm password: " pass2
        echo
        if [[ "$pass" == "$pass2" && -n "$pass" ]]; then
            echo "$pass" > "$PASSWD_FILE"
            echo -e "${COLOR_GREEN}[✓] Password saved in $PASSWD_FILE${COLOR_RESET}"
        else
            echo -e "${COLOR_RED}[!] Password mismatch or empty. Exiting.${COLOR_RESET}"
            exit 1
        fi
    fi
}

password_login() {
    local attempts=0
    while [[ $attempts -lt 3 ]]; do
        read -s -p "Enter system password: " input_pass
        echo
        if [[ "$(cat "$PASSWD_FILE")" == "$input_pass" ]]; then
            echo -e "${COLOR_GREEN}[✓] Access granted.${COLOR_RESET}"
            return 0
        else
            echo -e "${COLOR_RED}[✗] Wrong password.${COLOR_RESET}"
            ((attempts++))
        fi
    done
    echo -e "${COLOR_RED}[!] Too many failed attempts. Exiting.${COLOR_RESET}"
    exit 1
}

# ---------- FIRST RUN HACKING LOADING ----------
first_run_loading() {
    if [[ ! -f "$FIRST_RUN_FLAG" ]]; then
        echo -e "${COLOR_RED}[ SYSTEM BOOT ] Initializing DEX-HACKER environment...${COLOR_RESET}"
        for i in {1..5}; do
            echo -ne "${COLOR_YELLOW}Loading kernel modules ${i}0% ["
            for j in {1..$((i*4))}; do echo -n "#"; done
            for j in {1..$((20 - i*4))}; do echo -n " "; done
            echo -e "]${COLOR_RESET}"
            sleep 1
        done
        echo -e "${COLOR_GREEN}[✓] Hack environment ready.${COLOR_RESET}"
        touch "$FIRST_RUN_FLAG"
        sleep 1
    fi
}

# ---------- YOUTUBE AUDIO PLAYER (ad-free) ----------
play_youtube_audio() {
    echo -e "${COLOR_CYAN}Enter song name or YouTube URL:${COLOR_RESET}"
    read -r query
    if [[ -z "$query" ]]; then
        echo -e "${COLOR_RED}No input.${COLOR_RESET}"
        return
    fi
    if ! command -v yt-dlp &>/dev/null || ! command -v mpv &>/dev/null; then
        echo -e "${COLOR_RED}yt-dlp or mpv missing. Install with: pkg install yt-dlp mpv${COLOR_RESET}"
        return
    fi
    echo -e "${COLOR_GREEN}▶ Playing audio only (ad-free)...${COLOR_RESET}"
    yt-dlp -f "bestaudio" --no-playlist -o - "$query" | mpv --no-video - &>/dev/null
}

# ---------- CUSTOMIZATION (except IG username) ----------
customize_settings() {
    echo -e "${COLOR_YELLOW}--- Customization Menu ---${COLOR_RESET}"
    read -p "New display name (current: $USER_NAME): " newname
    [[ -n "$newname" ]] && USER_NAME="$newname"
    
    echo "Choose header color:"
    echo "1) Cyan (default)  2) Red  3) Green  4) Yellow"
    read -p "Choice [1-4]: " col_choice
    case $col_choice in
        2) COLOR_CYAN="\033[1;31m" ;;
        3) COLOR_CYAN="\033[1;32m" ;;
        4) COLOR_CYAN="\033[1;33m" ;;
        *) COLOR_CYAN="\033[1;36m" ;;
    esac
    
    read -p "Auto-play intro song on startup? (yes/no) [current: $AUTO_PLAY_SONG]: " autoplay
    [[ "$autoplay" == "yes" || "$autoplay" == "no" ]] && AUTO_PLAY_SONG="$autoplay"
    
    # Save settings (IG username is NOT saved here, remains hardcoded in banner)
    cat > "$CONFIG_FILE" <<EOF
USER_NAME="$USER_NAME"
COLOR_CYAN="$COLOR_CYAN"
COLOR_RED="\033[1;31m"
COLOR_GREEN="\033[1;32m"
COLOR_YELLOW="\033[1;33m"
COLOR_RESET="\033[0m"
AUTO_PLAY_SONG="$AUTO_PLAY_SONG"
EOF
    echo -e "${COLOR_GREEN}Settings saved!${COLOR_RESET}"
    sleep 1
}

# ---------- DEVELOPER SUPPORT OPTION ----------
developer_support() {
    echo -e "${COLOR_CYAN}Do you want developer support from Dex Shyam Tech? (yes/no)${COLOR_RESET}"
    read -r support_ans
    if [[ "$support_ans" == "yes" ]]; then
        echo -e "${COLOR_GREEN}Thank you! Reach out via:${COLOR_RESET}"
        echo "  • Instagram : @dex_shyam_42"
        echo "  • GitHub    : https://github.com/Dexsam07"
        echo "  • Email     : dexshyam@proton.me (example)"
    else
        echo -e "${COLOR_RED}You refused support. Dev might 'cut your job' 😈 (just kidding, but consider supporting open source!)${COLOR_RESET}"
    fi
    echo -e "\n${COLOR_YELLOW}Press Enter to continue...${COLOR_RESET}"
    read -r
}

# ---------- SHOW SOCIAL MEDIA (support links) ----------
show_social() {
    echo -e "${COLOR_GREEN}=== Support the Developer ===${COLOR_RESET}"
    echo "📱 Instagram : @dex_shyam_42"
    echo "🐙 GitHub    : https://github.com/Dexsam07"
    echo "🎵 Project   : termux-dex-hacker"
    echo "💬 DM for support / collaboration"
    echo -e "\n${COLOR_YELLOW}Press Enter to return...${COLOR_RESET}"
    read -r
}

# ---------- MAIN MENU ----------
main_menu() {
    while true; do
        real_time_header
        echo -e "${COLOR_GREEN}1)${COLOR_RESET} 🎵 Play YouTube Song (ad-free)"
        echo -e "${COLOR_GREEN}2)${COLOR_RESET} 🎶 Play Default Intro Song (now)"
        echo -e "${COLOR_GREEN}3)${COLOR_RESET} 🛠️  Customize (name/color/autoplay)"
        echo -e "${COLOR_GREEN}4)${COLOR_RESET} 💾 Show Storage & System Info"
        echo -e "${COLOR_GREEN}5)${COLOR_RESET} 🆘 Developer Support (yes/no)"
        echo -e "${COLOR_GREEN}6)${COLOR_RESET} 📢 Social Media & Credits"
        echo -e "${COLOR_GREEN}7)${COLOR_RESET} 🔐 Change System Password"
        echo -e "${COLOR_GREEN}8)${COLOR_RESET} ❌ Exit"
        echo -ne "${COLOR_CYAN}➤ Choose [1-8]: ${COLOR_RESET}"
        read -r choice
        case $choice in
            1) play_youtube_audio ;;
            2) mpv --no-video "$INTRO_SONG_URL" 2>/dev/null || echo "mpv missing" ;;
            3) customize_settings ;;
            4) echo -e "${COLOR_YELLOW}$(df -h)${COLOR_RESET}"; sleep 2 ;;
            5) developer_support ;;
            6) show_social ;;
            7) setup_password ;;
            8) echo -e "${COLOR_GREEN}Exiting DEX-HACKER. Stay dangerous!${COLOR_RESET}"; exit 0 ;;
            *) echo -e "${COLOR_RED}Invalid option${COLOR_RESET}"; sleep 1 ;;
        esac
    done
}

# ---------- ENTRY POINT ----------
main() {
    print_banner
    setup_password          # create password file if missing
    password_login          # enforce login
    first_run_loading       # show "hacking loading" only once
    play_song_background    # auto-play intro song (if enabled)
    main_menu
}

# Check dependencies before running
missing=()
for cmd in mpv yt-dlp; do
    if ! command -v $cmd &>/dev/null; then
        missing+=("$cmd")
    fi
done
if [[ ${#missing[@]} -gt 0 ]]; then
    echo -e "\033[1;31m[!] Missing: ${missing[*]}\033[0m"
    echo "Install them with: pkg install ${missing[*]}"
    echo "Then re-run this script."
    exit 1
fi

main
