
```markdown
# 🔥 DEX-HACKER – The Ultimate Termux Transformation

Turn your Termux into a dangerous-looking, fully-loaded hacking environment with YouTube audio streaming, password protection, auto‑playing intro, and real‑time branding.

![Demo](https://img.shields.io/badge/Termux-DEX--HACKER-red) ![Maintained](https://img.shields.io/badge/Maintained%3F-yes-green)

## ✨ Features
- 💀 5‑second “hacking” loading animation on every launch
- 🎵 Auto‑plays a custom MP3 (or any URL) once per session
- 🔒 Password‑lock command (`dex-lock`) – password stored in `~/.dex_hacker/.passwd`
- 🎧 Ad‑free YouTube song streaming: `playsong "song name"`
- 📁 Run any Python, HTML, JS, or shell script with `dex-run`
- 📱 Show internal & shared storage usage (`dex-storage`)
- 🔄 One‑command update (`dex-update`)
- 🛡️ Support toggle – disabling it will lock the script after 3 days
- ⏱️ Real‑time clock in the prompt
- 🖼️ Custom ASCII banner + Instagram credit (unchangeable)

## 🚀 Quick Install
```bash
pkg install git -y
git clone https://github.com/Dexsam07/termux-dex-hacker.git
cd termux-dex-hacker
bash install.sh
```

Then restart Termux.

📸 Screenshots

(Add your own screenshots here)

👨‍💻 Developer

· Dex Shyam Tech – @dex_shyam_42
· GitHub: Dexsam07

📜 License

MIT – feel free to modify, but keep the original credits.

```

## ✅ Final Notes

- The song will play **once per shell session** (not every time you open a new pane). The environment variable `DEX_HACKER_PLAYED` prevents replays.
- If you forget your password, simply `nano ~/.dex_hacker/.passwd` to see or change it.
- The `dex-support` command sets a flag. If you choose “no”, the script counts 3 days and then blocks execution until you manually edit the config back to `SUPPORT="yes"` (or run `dex-support` again inside the 3‑day window).
- All custom commands are available immediately after installation – no extra steps.
- The default Termux welcome message is gone – instead you get the DEX-HACKER banner.

Enjoy your legendary Termux environment! 😈
