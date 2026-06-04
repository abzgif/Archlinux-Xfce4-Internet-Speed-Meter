# XFCE4 Real-Time Network Speed Meter

An ultra-lightweight, high-performance network speed monitor designed specifically for the **XFCE4** desktop environment via the `xfce4-genmon-plugin`. Unlike native panel applets or poorly optimized scripts that use blocking `sleep` commands, this implementation uses a non-blocking **caching mechanism**. This ensures your panel updates flawlessly every single second without causing CPU spikes, panel freezing, or system hangs.

It formats data dynamically into `B/s`, `KiB/s`, or `MiB/s` and uses sharp typography styled to match clean, professional desktop setups.

---

## ⚡ Features

* 🚀 **Zero-Lag Architecture:** Implements a state-file caching system to calculate instantaneous throughput without freezing the XFCE panel thread.
* 📈 **Dynamic Scale Unit Auto-Switching:** Intelligently transitions formatting between `B/s`, `KiB/s`, and `MiB/s` depending on active traffic.
* 🎨 **Unified Clean UI:** Renders with clear, stylized text and direction indicators (`⬇` for Download, `⬆` for Upload) using a high-visibility bold font.
* 📊 **Live Session Tracking:** Includes a mouse hover tooltip that tracks total bandwidth consumption for the session.

---

## 📋 Prerequisites & Installation

### 1. Install the Generic Monitor Plugin
On **Arch Linux**, make sure you have the necessary panel extension:
```bash
sudo pacman -S xfce4-genmon-plugin awk
```

### 2. Identify Your Network Interface Name
Before deploying the script, you need to know the active name of your network adapter (Ethernet or Wi-Fi). Run this command in your terminal:
```bash
ip link show
```
Look for an interface that isn't `lo`. Common names include:
* `enp3s0` or `eth0` (for wired Ethernet)
* `wlan0` or `wlan1` (for Wi-Fi)

---

## 🚀 Setup & Script Deployment

### 1. Create and Write the Script
1. Create a script file in your local binary path:
   ```bash
   mkdir -p ~/.local/bin
   nano ~/.local/bin/net_speed.sh
   ```
2. Paste your optimized, stable network caching script into the file. Make sure your active interface name matches the target interface variable at the top of your script.
3. Save and close the file (`Ctrl+O`, `Enter`, `Ctrl+X`).
4. Give the file executable permissions so XFCE can run it:
   ```bash
   chmod +x ~/.local/bin/net_speed.sh
   ```

### 🛠️ Configure the XFCE Top Panel Item
1. Right-click your top bar/panel -> **Panel** -> **Add New Items...**
2. Search for **Generic Monitor** (`genmon`) and add it to your panel.
3. Right-click the newly added Generic Monitor text -> **Properties**.
4. Configure the parameters precisely like this:
   * **Command:** `/home/YOUR_USERNAME/.local/bin/net_speed.sh` *(Ensure you provide your literal absolute home directory path instead of a shortcut)*
   * **Label:** *Uncheck* (Keep this box empty to allow the custom text and arrows to look modern and minimal)
   * **Period (s):** Set this strictly to `1.00` (Since the script uses a cache-delta method, a 1-second period guarantees completely accurate, real-time tracking).
5. Click **Close**.

---

## 🎨 Typography & Design Profile
The script automatically exports perfectly compliant XFCE-Genmon XML markup. It structures the text in standard high-contrast formatting:
```xml
<txt><span font='Cascadia Code 10' weight='bold' color='#000000'>⬇ 1.2 MiB/s  ⬆ 45.8 KiB/s</span></txt>
```

## 📄 License
This utility is open-sourced under the MIT License. Feel free to copy, tweak, and integrate it into your dotfiles or desktop configurations!
