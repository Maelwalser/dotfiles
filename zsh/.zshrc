# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="my-darkblood"


# ALIAS
alias vim='nvim'

plugins=(
  git
  zsh-autosuggestions
  vi-mode
  zsh-syntax-highlighting
  )

ZSH_VI_MODE_SET_CURSOR=false

source $ZSH/oh-my-zsh.sh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#e0435e,standout"
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
ZSH_AUTOSUGGEST_USE_ASYNC=1


export GEMINI_API_KEY=$(pass show gemini/api_key)

eval "$(zoxide init zsh --cmd cd)"


# --- TMUX TOOLKIT ---
# (tma) - "Tmux Main Attach"
# Attaches to a session named "main", or creates it if it doesn't exist.
tma() {
  # Don't run if already inside tmux
  if [[ -n "$TMUX" ]]; then
    echo "Already inside tmux."
    return 1
  fi
  
  # Attach to session 'main' or create it
  tmux attach-session -t main || tmux new-session -s main
}

# (tn) - "Tmux New [name]"
# Creates a new, named session for a specific project.
tn() {
  if [[ -n "$TMUX" ]]; then
    echo "Already inside tmux. Detach first with 'Ctrl+b, d'."
    return 1
  fi

  # Check if a name was provided
  if [[ -z "$1" ]]; then
    echo "Usage: tn <session-name>"
    return 1
  fi

  tmux new-session -s "$1"
}

# (tl) - "Tmux List & Attach"
# Lists all sessions and provides an interactive fzf-based menu to attach.
tl() {
  if [[ -n "$TMUX" ]]; then
    echo "Already inside tmux."
    return 1
  fi

  local session
  session=$(tmux ls -F '#S' | fzf --reverse --prompt="❌ Select Tmux Session > ")
  
  if [[ -n "$session" ]]; then
    tmux attach-session -t "$session"
  fi
}

# (tk) - "Tmux Kill"
# Lists sessions and interactively prompts to kill one.
tk() {
  # Don't run if inside tmux
  if [[ -n "$TMUX" ]]; then
    echo "Cannot kill sessions from inside tmux. Detach first."
    return 1
  fi

  local session
  session=$(tmux ls -F '#S' | fzf --reverse --prompt="💀 KILL > ")

  if [[ -n "$session" ]]; then
    # Add a confirmation step
    echo -n "💀 KILL $session? [y/N] "
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
      tmux kill-session -t "$session"
      echo "$session KILLED ⚰️"
    else
      echo "KILL aborted ᶻ 𝗓 𐰁"
    fi
  fi
}

