#!/bin/bash

echo "╭────────────────────────────────────────────╮"
echo "│     ⚙️  Auto Detect - Simply Spicetify     │"
echo "╰────────────────────────────────────────────╯"
echo ""

OS=$(uname)

if [[ "$OS" == "Darwin" ]]; then
    echo "Detected OS: macOS"

    if command -v brew >/dev/null 2>&1; then
        echo "▶️ Installing spicetify via Homebrew..."
        brew install spicetify-cli
    else
        echo "⚠️ Brew not found. Using curl fallback..."
        curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
    fi

elif [[ "$OS" == "Linux" ]]; then
    echo "Detected OS: Linux"

    # Kalau ada snap Spotify, hapus
    if snap list spotify >/dev/null 2>&1; then
        echo "🗑 Removing snap spotify..."
        sudo snap remove spotify
    fi

    if command -v yay >/dev/null 2>&1; then
        echo "▶️ Installing spicetify via AUR (yay)..."
        yay -S --noconfirm spicetify-cli spotify
        echo "🔧 Fixing permissions for AUR spotify..."
        sudo chmod a+wr /opt/spotify
        sudo chmod -R a+wr /opt/spotify/Apps

    elif command -v paru >/dev/null 2>&1; then
        echo "▶️ Installing spicetify via AUR (paru)..."
        paru -S --noconfirm spicetify-cli spotify
        echo "🔧 Fixing permissions for AUR spotify..."
        sudo chmod a+wr /opt/spotify
        sudo chmod -R a+wr /opt/spotify/Apps

    elif command -v flatpak >/dev/null 2>&1; then
        echo "▶️ Installing Spotify via Flatpak..."
        flatpak install -y flathub com.spotify.Client
        echo "🔧 Fixing permissions for Flatpak spotify..."
        sudo chmod a+wr /var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify
        sudo chmod -R a+wr /var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify/Apps
        echo "▶️ Installing spicetify via curl..."
        curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
        echo "⚙️ Setting prefs_path for Flatpak..."
        spicetify config prefs_path ~/.var/app/com.spotify.Client/config/spotify/prefs

    elif command -v apt-get >/dev/null 2>&1; then
        echo "▶️ Installing Spotify via apt..."
        curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
        echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
        sudo apt-get update && sudo apt-get install -y spotify-client
        echo "🔧 Fixing permissions for apt spotify..."
        sudo chmod a+wr /usr/share/spotify
        sudo chmod -R a+wr /usr/share/spotify/Apps
        echo "▶️ Installing spicetify via curl..."
        curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
    else
        echo "⚠️ No supported package manager found. Using curl fallback..."
        curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
    fi

elif [[ "$OS" == MINGW* || "$OS" == CYGWIN* ]]; then
    echo "Detected OS: Windows"
    echo "▶️ Installing spicetify via PowerShell..."
    powershell -Command "iwr -useb https://raw.githubusercontent.com/spicetify/cli/main/install.ps1 | iex"

else
    echo "❌ Unsupported OS."
    exit 1
fi

echo ""
echo "🎉 Ritual complete. Your IDE is fully enchanted."
sleep 5
echo ""
echo "🚀 Launch Spotify."
