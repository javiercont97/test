#!/usr/bin/env bash
set -euo pipefail

# Interactive for manual config
INTERACTIVE_INSTALL=${1:-true}

# ===========
# CONFIG
# ===========
ZSH="${ZSH:-$HOME/.oh-my-zsh}"
ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH/custom}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}" # change if needed
ZSHRC="$HOME/.zshrc"

# ===========
# FUNCTIONS
# ===========

install_pkg() {
    if command -v yay >/dev/null 2>&1; then
        yay -S --needed --noconfirm "$@"
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -S --needed --noconfirm "$@"
    else
        echo "No supported package manager (yay or pacman) found!"
        exit 1
    fi
}

# ===========
# INSTALL ZSH
# ===========
if ! command -v zsh >/dev/null 2>&1; then
    echo "[*] Installing zsh..."
    install_pkg zsh
fi

# ===========
# INSTALL OH-MY-ZSH
# ===========
if [ ! -d "$ZSH" ]; then
    echo "[*] Installing Oh My Zsh..."
    RUNZSH=no KEEP_ZSHRC=yes sh -c \
        "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "[*] Oh My Zsh already installed."
fi

# ===========
# INSTALL MESLO NERD FONT (Recommended for Powerlevel10k)
# ===========
if ! fc-list | grep -i "MesloLGS NF" >/dev/null 2>&1; then
    echo "[*] Installing MesloLGS NF font (recommended for Powerlevel10k)..."
    install_pkg ttf-meslo-nerd-font-powerlevel10k
    echo "[✔] Font installed. You may need to restart your terminal and set MesloLGS NF as your terminal font."
else
    echo "[*] MesloLGS NF font already installed."
fi

# ===========
# INSTALL POWERLEVEL10K
# ===========
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    echo "[*] Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "$ZSH_CUSTOM/themes/powerlevel10k"
else
    echo "[*] Powerlevel10k already installed."
fi

# ===========
# ADDITIONAL PLUGINS
# ===========
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "[*] Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "[*] Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
        "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# ===========
# CONFIGURE .zshrc
# ===========
echo "[*] Configuring .zshrc..."

# Backup existing
[ -f "$ZSHRC" ] && cp "$ZSHRC" "$ZSHRC.backup.$(date +%s)"

cat > "$ZSHRC" <<EOF
export ZSH="$ZSH"

ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source \$ZSH/oh-my-zsh.sh

# To customize Powerlevel10k prompt, run 'p10k configure' or edit ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOF

# ===========
# DEFAULT SHELL TO ZSH
# ===========
if [ "$SHELL" != "$(command -v zsh)" ]; then
    echo "[*] Changing default shell to zsh..."
    chsh -s "$(command -v zsh)"
fi

echo "[✔] Zsh setup complete! Restart terminal or run 'exec zsh'."
