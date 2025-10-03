# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# fastfetch  # uncomment for fastfetch hushlogin

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git archlinux zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

##################################################
# User configurations
##################################################

# Git agent
# eval "$(ssh-agent -s)" >/dev/null 2>&1
# ssh-add ~/.ssh/id_rsa >/dev/null 2>&1

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
