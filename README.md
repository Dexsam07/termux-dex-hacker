# 🔥 DEX-HACKER - Military Grade Termux Environment 🔥

**Developer:** Dex Shyam Tech | Instagram: @dex_shyam_42  
**Project:** Ultimate Termux hacking environment with password protection, ad‑free YouTube, localhost server, AI tools, Telegram bot integration, and real‑time branding.

## 🚀 Features

- **Khatarnak loading animation** + background song (custom URL)
- **Password‑protected access** (password stored in `~/.dex_hacker/.password` – view with `nano` if forgotten)
- **Real‑time prompt** with DEX-HACKER branding and live clock
- **Ad‑free YouTube audio streaming** (no video – saves bandwidth)
- **Localhost web server** (port 8080) – run HTML/JS/CSS/Python scripts instantly
- **3 Free AI Tools** (ChatGPT‑like, online research, daily tips)
- **Telegram Bot** (encrypted token) – notifies admin about user logins, support requests, and server starts
- **Developer Support menu** (Yes/No) – sends alert to Telegram or shows "Naukari karke cut" message
- **Network speed test** (lightweight)
- **Fully customizable** – change password, stop/start local server, add your own tools in `~/.dex_hacker/www/`

## 📦 Installation (One‑time)

```bash
git clone https://github.com/Dexsam07/termux-dex-hacker.git
cd termux-dex-hacker
bash install.sh

🔧 FIX - Direct Local Installation (Bina GitHub ke)

Aap abhi ke abhi apne phone mein direct files bana sakte ho aur run kar sakte ho. Neche diye steps follow karo:

Step 1: Required folders aur files manually banao

```bash
# Termux mein ye commands run karo

# Folders banao
mkdir -p ~/.dex_hacker/{www,logs,bin}
mkdir -p ~/termux-dex-hacker

# Password file banao
echo "dex@123" > ~/.dex_hacker/.password

# Web root dummy file
echo "<h1>DEX-HACKER Local Server</h1>" > ~/.dex_hacker/www/index.html
```

Step 2: Main script dex-hacker.sh banao

```bash
nano ~/.dex_hacker/bin/dex-hacker.sh
```

Uske baad maine jo upar dex-hacker.sh ka code diya hai – use copy-paste karo.
Save karo (Ctrl+O, Enter, Ctrl+X).

Phir executable banao:

```bash
chmod +x ~/.dex_hacker/bin/dex-hacker.sh
```

Step 3: Autostart add karo .bashrc mein

```bash
echo -e "\n# DEX-HACKER autostart\nbash ~/.dex_hacker/bin/dex-hacker.sh\n" >> ~/.bashrc
```

Step 4: Dependencies install karo

```bash
pkg update -y
pkg install mpv yt-dlp python curl wget git nano -y
```

Step 5: Termux restart karo

Band karke fir se kholo. Ab DEX-HACKER load hoga!

---
