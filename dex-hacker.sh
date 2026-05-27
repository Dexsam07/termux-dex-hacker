#!/data/data/com.termux/files/usr/bin/bash

# ==============================================
# DEX-HACKER TERMINAL – BY DEX SHYAM TECH
# KHATARNAK LEVEL PRO MAX
# ==============================================

# ---- Immutable Developer Branding ----
readonly DEV_NAME="Dex Shyam Tech"
readonly INSTA="@dex_shyam_42"
readonly PROJECT="termux-dex-hacker"
readonly REPO_URL="https://github.com/Dexsam07/termux-dex-hacker"
readonly SONG_URL="https://files.catbox.moe/e4fmn4.mp3"

# ---- Directories & Files ----
DEX_DIR="$HOME/.dex_hacker"
PASS_FILE="$DEX_DIR/password.txt"
CONFIG_FILE="$DEX_DIR/config.cfg"
mkdir -p "$DEX_DIR"

# ---- Colors ----
RED='\033[1;91m'
GREEN='\033[1;92m'
YELLOW='\033[1;93m'
BLUE='\033[1;94m'
PURPLE='\033[1;95m'
CYAN='\033[1;96m'
WHITE='\033[1;97m'
RESET='\033[0m'
BOLD='\033[1m'

# ---- Check Dependencies ----
deps=(mpv yt-dlp curl)
missing=()
for dep in "${deps[@]}"; do
    if ! command -v "$dep" &>/dev/null; then
        missing+=("$dep")
    fi
done
if [ ${#missing[@]} -gt 0 ]; then
    echo -e "${YELLOW}[!] Missing: ${missing[*]}${RESET}"
    echo -e "${GREEN}[+] Installing...${RESET}"
    pkg update -y && pkg install -y mpv yt-dlp curl
fi

# ---- Password System ----
init_password() {
    if [ ! -f "$PASS_FILE" ]; then
        echo -e "${CYAN}[!] First run – set your system password:${RESET}"
        read -s -p "New password: " user_pass
        echo
        echo -n "$user_pass" > "$PASS_FILE"
        echo -e "${GREEN}[✓] Password stored securely in $PASS_FILE${RESET}"
        echo -e "${YELLOW}⚠️  If you forget it, type: nano $PASS_FILE${RESET}"
    fi
}

check_password() {
    local stored_pass=$(cat "$PASS_FILE")
    read -s -p "${CYAN}🔐 Enter system password: ${RESET}" input_pass
    echo
    if [[ "$input_pass" != "$stored_pass" ]]; then
        echo -e "${RED}❌ Wrong password! Exiting.${RESET}"
        exit 1
    fi
}

# ---- Loading Animation (5 sec + song) ----
loading_screen() {
    clear
    echo -e "${RED}"
    cat << "EOF"
██████╗ ███████╗██╗  ██╗     ██╗  ██╗ █████╗  ██████╗██╗  ██╗███████╗██████╗ 
██╔══██╗██╔════╝╚██╗██╔╝     ██║  ██║██╔══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗
██║  ██║█████╗   ╚███╔╝█████╗███████║███████║██║     █████╔╝ █████╗  ██████╔╝
██║  ██║██╔══╝   ██╔██╗╚════╝██╔══██║██╔══██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗
██████╔╝███████╗██╔╝ ██╗     ██║  ██║██║  ██║╚██████╗██║  ██╗███████╗██║  ██║
╚═════╝ ╚══════╝╚═╝  ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
EOF
    echo -e "${RESET}"
    echo -e "${CYAN}⚡ DEVELOPER : $DEV_NAME${RESET}"
    echo -e "${PURPLE}📱 INSTAGRAM : $INSTA${RESET}"
    echo -e "${YELLOW}🔗 REPO : $REPO_URL${RESET}"
    echo -e "${BLUE}⏱️  REAL-TIME : $(date '+%H:%M:%S %d-%b-%Y')${RESET}"
    echo -e "${RED}🔥 LOADING KHATARNAK HACKER TOOLS... 🔥${RESET}"
    
    # Play MP3 in background
    mpv --no-video --really-quiet "$SONG_URL" &>/dev/null &
    MPV_PID=$!
    
    # 5 second hacker spinner
    spin=('█░░░' '░█░░' '░░█░' '░░░█')
    for i in {1..5}; do
        printf "\r${YELLOW}[${spin[$((i%4))]}] Hacking terminal loading... %d sec${RESET}" $((5-i))
        sleep 1
    done
    printf "\r${GREEN}[✓] System Ready!                 ${RESET}\n"
    sleep 0.5
    kill $MPV_PID 2>/dev/null
}

# ---- Real-time Prompt Branding ----
set_prompt() {
    PS1="\[\e[1;91m\]╭──(DEX-HACKER@$(date +%H:%M:%S))\[\e[0m\]\n\[\e[1;92m\]╰─➤ \[\e[0m\]"
}

# ---- Tools & Functions ----
show_storage() {
    echo -e "${CYAN}📂 STORAGE INFO (Phone/PC):${RESET}"
    df -h | grep -E '(/dev/block|/data|/storage|C:)'
}

network_speed() {
    echo -e "${YELLOW}📡 Measuring network speed (approx)...${RESET}"
    start=$(date +%s%N)
    curl -s -o /dev/null http://speedtest.tele2.net/10MB.zip
    end=$(date +%s%N)
    elapsed=$((($end - $start)/1000000))
    speed=$((10*1000/elapsed))
    echo -e "${GREEN}⚡ Speed: ~$speed MB/s (10MB downloaded in ${elapsed}ms)${RESET}"
}

youtube_song() {
    echo -e "${CYAN}🎵 Enter song name:${RESET}"
    read -r song
    echo -e "${GREEN}▶️ Playing (AD-FREE)...${RESET}"
    yt-dlp -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 -o - "ytsearch1:$song" | mpv --no-video -
}

ai_tools_menu() {
    echo -e "${PURPLE}🤖 FREE AI TOOLS MENU:${RESET}"
    echo "1. ChatGPT (Web)"
    echo "2. Google Bard (Gemini)"
    echo "3. Microsoft Copilot"
    echo "4. Research Tool (Wikipedia/DuckDuckGo)"
    read -p "Choose [1-4]: " ai_choice
    case $ai_choice in
        1) termux-open-url "https://chat.openai.com" ;;
        2) termux-open-url "https://gemini.google.com" ;;
        3) termux-open-url "https://copilot.microsoft.com" ;;
        4) 
            read -p "🔍 Search query: " query
            curl -s "https://en.wikipedia.org/api/rest_v1/page/summary/$(echo $query | sed 's/ /_/g')" | grep -o '"extract":"[^"]*"' | cut -d'"' -f4
            ;;
        *) echo -e "${RED}Invalid${RESET}" ;;
    esac
}

run_custom_file() {
    echo -e "${CYAN}📁 Enter file path (HTML/JS/PY):${RESET}"
    read -r filepath
    if [[ "$filepath" == *.html ]]; then
        termux-open "$filepath"
    elif [[ "$filepath" == *.js ]]; then
        node "$filepath"
    elif [[ "$filepath" == *.py ]]; then
        python "$filepath"
    else
        echo -e "${RED}Unsupported file type${RESET}"
    fi
}

developer_support() {
    echo -e "${YELLOW}🤝 Developer Support Option${RESET}"
    read -p "Do you want support from $DEV_NAME? (yes/no): " support
    if [[ "$support" == "yes" ]]; then
        echo -e "${GREEN}✅ You have active support. Contact $INSTA${RESET}"
    else
        echo -e "${RED}❌ Support rejected. Developer has cut your job access.${RESET}"
        echo -e "${RED}You will be logged out in 5 seconds.${RESET}"
        sleep 5
        exit 1
    fi
}

# ---- Main Menu ----
main_menu() {
    while true; do
        clear
        echo -e "${RED}══════════════════════════════════════════${RESET}"
        echo -e "${BOLD}    DEX-HACKER CONTROL PANEL – $DEV_NAME${RESET}"
        echo -e "${RED}══════════════════════════════════════════${RESET}"
        echo -e "${CYAN}1) 🎵 YouTube Song Player (Ad-Free)${RESET}"
        echo -e "${CYAN}2) 🌐 Network Speed Test${RESET}"
        echo -e "${CYAN}3) 🤖 AI Tools + Research${RESET}"
        echo -e "${CYAN}4) 🛠️ Run Custom File (HTML/JS/PY)${RESET}"
        echo -e "${CYAN}5) 💾 Show Storage Info${RESET}"
        echo -e "${CYAN}6) 🔑 Change System Password${RESET}"
        echo -e "${CYAN}7) 🆘 Developer Support (Yes/No)${RESET}"
        echo -e "${RED}8) 🚪 Exit${RESET}"
        echo -e "${RED}══════════════════════════════════════════${RESET}"
        read -p "Choose option: " opt
        case $opt in
            1) youtube_song ;;
            2) network_speed ;;
            3) ai_tools_menu ;;
            4) run_custom_file ;;
            5) show_storage ;;
            6) 
                echo -e "${YELLOW}Change password:${RESET}"
                read -s -p "New password: " newpass
                echo -n "$newpass" > "$PASS_FILE"
                echo -e "${GREEN}Password updated.${RESET}"
                ;;
            7) developer_support ;;
            8) echo -e "${GREEN}Stay dangerous! DEX-HACKER signing off.${RESET}"; exit 0 ;;
            *) echo -e "${RED}Invalid option${RESET}" ;;
        esac
        read -p "Press Enter to continue..."
    done
}

# ---- Main Execution ----
init_password
check_password
loading_screen
set_prompt
clear
echo -e "${GREEN}✅ Type 'menu' to open control panel anytime.${RESET}"
echo -e "${CYAN}⚡ Fast commands: ytsong 'name' | speedtest | storage${RESET}"
alias ytsong=youtube_song
alias speedtest=network_speed
alias storage=show_storage
alias menu=main_menu
main_menu
