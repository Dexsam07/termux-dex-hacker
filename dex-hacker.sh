#!/data/data/com.termux/files/usr/bin/bash

# ==============================================
# DEX-HACKER - Termux Ultimate Framework
# Developer: Dex Shyam Tech | IG: @dex_shyam_42
# GitHub: Dexsam07/termux-dex-hacker
# ==============================================

# ---- Protect developer identity (hardcoded & immutable) ----
DEV_NAME="Dex Shyam Tech"
DEV_IG="@dex_shyam_42"
DEV_GITHUB="Dexsam07"
BRAND="DEX-HACKER"
PROJECT="Termux DeX Hacker"

# ---- File paths ----
PASSWD_FILE="$HOME/.dex_hacker_pass"
LOGIN_FLAG="$HOME/.dex_hacker_loggedin"
DEFAULT_SONG_URL="https://files.catbox.moe/e4fmn4.mp3"

# ---- Colors for UI ----
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# ---- Real-time clock (shown in banner) ----
get_time() { date +"%H:%M:%S - %d/%m/%Y"; }

# ---- Hacking loading animation (5 seconds) ----
loading_animation() {
    clear
    echo -e "${RED}   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄"
    echo -e "  ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌"
    echo -e "  ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌"
    echo -e "  ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌"
    echo -e "  ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌▐░▌       ▐░▌"
    echo -e "  ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░▌       ▐░▌"
    echo -e "  ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░▌       ▐░▌▐░▌       ▐░▌"
    echo -e "  ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌"
    echo -e "  ▐░▌       ▐░▌▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌"
    echo -e "  ▐░▌       ▐░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌"
    echo -e "   ▀         ▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀${NC}"
    echo -e "${CYAN}               ⚡ INITIALIZING HACKING MODULES ⚡${NC}"
    
    chars=( '|' '/' '-' '\' )
    for i in {1..50}; do
        idx=$(( i % 4 ))
        echo -ne "\r${YELLOW}[${chars[$idx]}] Loading kernel exploits... ${i}%${NC}"
        sleep 0.1
    done
    echo -e "\n${GREEN}✓ System breached. Welcome to ${BRAND}${NC}"
    sleep 1
}

# ---- Play default song once in background ----
play_default_song() {
    if command -v mpv &>/dev/null; then
        mpv --no-terminal --volume=70 "$DEFAULT_SONG_URL" >/dev/null 2>&1 &
    else
        echo -e "${RED}mpv not installed. Cannot play song.${NC}"
    fi
}

# ---- Check and install dependencies ----
check_deps() {
    deps=("mpv" "yt-dlp" "curl" "jq")
    missing=()
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            missing+=("$dep")
        fi
    done
    if [ ${#missing[@]} -ne 0 ]; then
        echo -e "${YELLOW}[!] Missing: ${missing[*]}. Installing...${NC}"
        pkg update -y && pkg install -y "${missing[@]}"
        echo -e "${GREEN}[✓] Dependencies installed.${NC}"
    fi
}

# ---- Password system (file stored in home) ----
password_setup() {
    if [ ! -f "$PASSWD_FILE" ]; then
        echo -e "${CYAN}[+] First launch - Set your master password:${NC}"
        read -s -p "New password: " pass1
        echo
        read -s -p "Confirm password: " pass2
        echo
        if [ "$pass1" == "$pass2" ] && [ -n "$pass1" ]; then
            echo "$pass1" > "$PASSWD_FILE"
            chmod 600 "$PASSWD_FILE"
            echo -e "${GREEN}[✓] Password saved.${NC}"
        else
            echo -e "${RED}[!] Mismatch or empty. Exiting.${NC}"
            exit 1
        fi
    fi
}

password_login() {
    attempts=3
    while [ $attempts -gt 0 ]; do
        read -s -p "Enter DEX-HACKER password: " input_pass
        echo
        stored_pass=$(cat "$PASSWD_FILE")
        if [ "$input_pass" == "$stored_pass" ]; then
            echo -e "${GREEN}[✓] Access granted.${NC}"
            return 0
        else
            attempts=$((attempts-1))
            echo -e "${RED}[!] Wrong password. $attempts attempts left.${NC}"
        fi
    done
    echo -e "${RED}[!] Authentication failed. Exiting.${NC}"
    exit 1
}

# ---- Banner with real-time clock ----
show_banner() {
    clear
    echo -e "${RED}██████╗ ███████╗██╗  ██╗     ██╗  ██╗ █████╗  ██████╗██╗  ██╗███████╗██████╗ ${NC}"
    echo -e "${RED}██╔══██╗██╔════╝╚██╗██╔╝     ██║  ██║██╔══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗${NC}"
    echo -e "${RED}██║  ██║█████╗   ╚███╔╝█████╗███████║███████║██║     █████╔╝ █████╗  ██████╔╝${NC}"
    echo -e "${RED}██║  ██║██╔══╝   ██╔██╗╚════╝██╔══██║██╔══██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗${NC}"
    echo -e "${RED}██████╔╝███████╗██╔╝ ██╗     ██║  ██║██║  ██║╚██████╗██║  ██╗███████╗██║  ██║${NC}"
    echo -e "${RED}╚═════╝ ╚══════╝╚═╝  ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝${NC}"
    echo -e "${CYAN}                    🧨 ${BRAND} v3.0 | ${DEV_NAME} 🧨${NC}"
    echo -e "${YELLOW}    ⏱️  REAL-TIME: $(get_time)     📱 DEVICE: $(uname -o)${NC}"
    echo -e "${WHITE}    🔗 IG: ${DEV_IG}  |  🐙 GitHub: ${DEV_GITHUB}${NC}"
    echo -e "${PURPLE}────────────────────────────────────────────────────────────${NC}"
}

# ---- YouTube song player (ad‑free) ----
play_youtube_song() {
    echo -e "${CYAN}🎵 Enter YouTube song name or URL:${NC}"
    read -r query
    if [[ -z "$query" ]]; then
        echo -e "${RED}No input.${NC}"
        return
    fi
    echo -e "${YELLOW}Streaming audio... (press Ctrl+C to stop)${NC}"
    yt-dlp -f bestaudio --no-playlist -o - "$query" | mpv --no-video -
}

# ---- AI tools (3 free) ----
ai_chat() {
    echo -e "${CYAN}🤖 Ask AI anything (powered by Pollinations):${NC}"
    read -r prompt
    if [[ -z "$prompt" ]]; then return; fi
    encoded=$(echo "$prompt" | jq -sRr @uri)
    response=$(curl -s "https://text.pollinations.ai/prompt/${encoded}")
    echo -e "${GREEN}AI: ${response}${NC}"
}

ai_research() {
    echo -e "${CYAN}🔍 Enter research topic:${NC}"
    read -r topic
    if [[ -z "$topic" ]]; then return; fi
    encoded=$(echo "$topic" | jq -sRr @uri)
    data=$(curl -s "https://api.duckduckgo.com/?q=${encoded}&format=json&no_html=1&skip_disambig=1")
    abstract=$(echo "$data" | jq -r '.AbstractText // "No summary found."')
    echo -e "${GREEN}📚 Summary: ${abstract}${NC}"
}

ai_code_helper() {
    echo -e "${CYAN}💻 Describe code problem:${NC}"
    read -r problem
    if [[ -z "$problem" ]]; then return; fi
    encoded=$(echo "Help me with code: $problem" | jq -sRr @uri)
    answer=$(curl -s "https://text.pollinations.ai/prompt/${encoded}")
    echo -e "${GREEN}🛠️ Suggestion: ${answer}${NC}"
}

# ---- Network usage & internet speed meter ----
network_speed() {
    echo -e "${YELLOW}📡 Testing download speed (approx)...${NC}"
    start=$(date +%s%N)
    curl -s -o /dev/null "http://speedtest.tele2.net/1MB.zip"
    end=$(date +%s%N)
    duration=$(( (end - start) / 1000000 ))
    if [ $duration -gt 0 ]; then
        speed=$(( 1024 / duration ))
        echo -e "${GREEN}🌐 Download speed: ~${speed} MB/s${NC}"
    else
        echo -e "${RED}Could not measure.${NC}"
    fi
    echo -e "${CYAN}📶 Connection info: $(termux-wifi-connectioninfo 2>/dev/null || echo 'N/A')${NC}"
}

# ---- Daily tip (random) ----
daily_tip() {
    tips=(
        "Use 'termux-open-url' to browse from terminal."
        "Install 'htop' for process monitoring."
        "You can run background tasks with '&'."
        "Alias 'll' = 'ls -la' saves time."
        "Use 'pkg list-all' to see available packages."
    )
    rand=$(( RANDOM % ${#tips[@]} ))
    echo -e "${CYAN}💡 TIP: ${tips[$rand]}${NC}"
}

# ---- Developer support & social media ----
dev_support() {
    echo -e "${YELLOW}🔧 Need developer support? (yes/no)${NC}"
    read -r ans
    if [[ "$ans" == "yes" ]]; then
        echo -e "${GREEN}📧 Contact Dex Shyam Tech via Instagram: ${DEV_IG}${NC}"
        echo -e "${CYAN}   GitHub issues: https://github.com/${DEV_GITHUB}/termux-dex-hacker/issues${NC}"
        termux-open-url "https://instagram.com/_u/dex_shyam_42"
    else
        echo -e "${RED}❌ Support declined. Developer may restrict service in future updates.${NC}"
    fi
}

# ---- Password recovery guidance ----
password_recovery() {
    echo -e "${YELLOW}🔐 Forgotten password? Use: nano $PASSWD_FILE${NC}"
    echo -e "${CYAN}   (inside Termux) to view or reset it.${NC}"
}

# ---- Main interactive menu ----
main_menu() {
    while true; do
        show_banner
        echo -e "${WHITE}   [01] 🎵 Play YouTube Song (ad‑free)${NC}"
        echo -e "   [02] 🤖 AI Chat (Pollinations)${NC}"
        echo -e "   [03] 📚 AI Research Assistant${NC}"
        echo -e "   [04] 💻 AI Code Helper${NC}"
        echo -e "   [05] 🌐 Network Speed Test${NC}"
        echo -e "   [06] 💡 Daily Tip${NC}"
        echo -e "   [07] 🔧 Developer Support${NC}"
        echo -e "   [08] 🔐 Password Recovery Info${NC}"
        echo -e "   [09] 🚪 Exit DEX-HACKER${NC}"
        echo -e "${PURPLE}────────────────────────────────────────────────────────────${NC}"
        read -p "⚡ Select option: " choice
        case $choice in
            1) play_youtube_song ;;
            2) ai_chat ;;
            3) ai_research ;;
            4) ai_code_helper ;;
            5) network_speed ;;
            6) daily_tip ;;
            7) dev_support ;;
            8) password_recovery ;;
            9) echo -e "${GREEN}Exiting to normal Termux. Stay dangerous.${NC}"; break ;;
            *) echo -e "${RED}Invalid.${NC}" ;;
        esac
        echo -e "\n${YELLOW}Press Enter to continue...${NC}"
        read -r
    done
}

# ---- Main execution flow ----
main() {
    check_deps
    password_setup
    password_login
    loading_animation
    play_default_song
    main_menu
}

# ---- Protect from direct execution without login ----
if [[ "$0" == "$BASH_SOURCE" ]]; then
    main
fi
