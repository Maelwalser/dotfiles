ZSH_THEME="my-darkblood"

# ALIAS
alias vim='nvim'
alias lg='lazygit'
alias killall='ka'

# Plugins
plugins=(
  git
  zsh-autosuggestions
  vi-mode
  zsh-syntax-highlighting
  )
source $ZSH/oh-my-zsh.sh

# Plugins settings
ZSH_VI_MODE_SET_CURSOR=false
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6b5d5a,standout"
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
ZSH_AUTOSUGGEST_USE_ASYNC=1


# Tools
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
    echo "Already inside tmux. Detach first with 'Ctrl+space, d'."
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
  if [[ -n "$TMUX" ]]; then
    echo "Cannot kill sessions from inside tmux. Detach first."
    return 1
  fi

  local session
  session=$(tmux ls -F '#S' | fzf --reverse --prompt="💀 KILL > ")

  if [[ -n "$session" ]]; then
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

# --- Nice to have ---
# Weather function
weather() {
  curl wttr.in/bern
}

# --- Keybinds ---

# vi-mode
# Unbinding uneeded binds
bindkey -r -M viins '^J' # Enter/LF (accept-line)
bindkey -r -M viins '^A' # beginning-of-line
bindkey -r -M viins '^B' # self-insert
bindkey -r -M viins '^C' # self-insert
bindkey -r -M viins '^D' # list-choices
bindkey -r -M viins '^E' # end-of-line
bindkey -r -M viins '^F' # self-insert
bindkey -r -M viins '^G' # list-expand
bindkey -r -M viins '^H' # backward-delete-char (we rely on ^?)
bindkey -r -M viins '^K' # self-insert
bindkey -r -M viins '^N' # down-history
bindkey -r -M viins '^O' # self-insert
bindkey -r -M viins '^P' # up-history
bindkey -r -M viins '^Q' # vi-quoted-insert
bindkey -r -M viins '^R' # history-incremental-search-backward
bindkey -r -M viins '^S' # history-incremental-search-forward
bindkey -r -M viins '^T' # self-insert
bindkey -r -M viins '^U' # vi-kill-line (your example)
bindkey -r -M viins '^V' # vi-quoted-insert
bindkey -r -M viins '^W' # backward-kill-word
bindkey -r -M viins '^Y' # self-insert
bindkey -r -M viins '^Z' # self-insert

# Unbind complex ^X chord bindings
bindkey -r -M viins '^X^R'
bindkey -r -M viins '^X?'
bindkey -r -M viins '^XC'
bindkey -r -M viins '^Xa'
bindkey -r -M viins '^Xc'
bindkey -r -M viins '^Xd'
bindkey -r -M viins '^Xe'
bindkey -r -M viins '^Xh'
bindkey -r -M viins '^Xm'
bindkey -r -M viins '^Xn'
bindkey -r -M viins '^Xt'
bindkey -r -M viins '^X~'



