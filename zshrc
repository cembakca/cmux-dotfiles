# =============================================================================
# ZSH CONFIG
# =============================================================================


# --- Oh My Zsh ------------------------------------------------------------

export ZSH="$HOME/.oh-my-zsh"

# Prompt'u Oh My Zsh yerine Starship yonetecek.
ZSH_THEME=""

# Fazla plugin shell acilisini yavaslatabilecegi icin minimal tutuyoruz.
plugins=(git)

source "$ZSH/oh-my-zsh.sh"


# --- PATH -----------------------------------------------------------------

# Kullanici seviyesinde kurulan araclar.
# Sistem/Homebrew dizinlerine yazma yetkisi gerektirmez.
export PATH="$HOME/.npm-global/bin:$HOME/.local/bin:$HOME/.dotnet:$PATH"


# --- NVM / Node.js --------------------------------------------------------

export NVM_DIR="$HOME/.nvm"

[ -s "$NVM_DIR/nvm.sh" ] && \
  source "$NVM_DIR/nvm.sh"

[ -s "$NVM_DIR/bash_completion" ] && \
  source "$NVM_DIR/bash_completion"


# --- pnpm -----------------------------------------------------------------

export PNPM_HOME="$HOME/Library/pnpm"

case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac


# --- Antigravity ----------------------------------------------------------

export PATH="$HOME/.antigravity/antigravity/bin:$PATH"


# --- Safe-chain -----------------------------------------------------------

# Safe-chain Zsh initialization.
[ -f "$HOME/.safe-chain/scripts/init-posix.sh" ] && \
  source "$HOME/.safe-chain/scripts/init-posix.sh"


# =============================================================================
# SHELL EXPERIENCE
# =============================================================================


# --- History --------------------------------------------------------------

# Farkli cmux pane'leri ayni command history'yi paylassin.
setopt SHARE_HISTORY

# Tekrarlanan komutlari history'de temiz tut.
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS

HISTSIZE=50000
SAVEHIST=50000
HISTFILE="$HOME/.zsh_history"


# --- Navigation -----------------------------------------------------------

# Daha once ziyaret ettigin klasorlere:
#
#   z cortex
#   z velox
#
# gibi gecis yapabilmeni saglar.
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi


# --- Fuzzy search ---------------------------------------------------------

# Ctrl-R ile history arama ve fzf shell entegrasyonu.
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

# --- Git worktrees --------------------------------------------------------

# Aktif worktree'leri listele.
alias wt="git worktree list"

# Interaktif ve guvenli worktree temizligi.
alias wtc="cmux-wt-clean"

# Git'in prune edecegi kayitlari silmeden once goster.
alias wtprune="git worktree prune --dry-run --verbose"

# --- CLI aliases ----------------------------------------------------------

# macOS built-in ls kullaniyoruz.
# Sirket bilgisayarinda eza icin ek package manager kurmuyoruz.
alias l="ls -G"
alias ll="ls -lahG"

# bat ile syntax-highlighted dosya goruntuleme.
if command -v bat >/dev/null 2>&1; then
  alias c="bat --paging=never"
fi


# --- Prompt ---------------------------------------------------------------

# Minimal prompt'u Starship yonetsin.
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi


# --- Autosuggestions ------------------------------------------------------

# History'deki eski komutlardan inline oneriler gosterir.
if [ -f "$HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi


# --- Syntax highlighting --------------------------------------------------

# Gecerli/gecersiz komutlari yazarken renklendirir.
#
# ZLE hook'lari kullandigi icin mümkün oldugunca dosyanin sonunda tutulmali.
if [ -f "$HOME/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "$HOME/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
# --- Lazygit --------------------------------------------------------------
# Git islemleri icin terminal UI.
alias lg="lazygit"


# --- Yazi -----------------------------------------------------------------

# Yazi'de gezip ciktiginda shell'i son klasore tasir.
function y() {
  local tmp cwd

  tmp="$(mktemp -t yazi-cwd.XXXXXX)"

  yazi "$@" --cwd-file="$tmp"

  if cwd="$(cat "$tmp" 2>/dev/null)" &&
     [ -n "$cwd" ] &&
     [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi

  rm -f -- "$tmp"
}
# --- Yazi -----------------------------------------------------------------

# Yazi'den cikinca shell'i son gezilen klasore tasir.
function y() {
  local tmp cwd

  tmp="$(mktemp -t yazi-cwd.XXXXXX)"

  yazi "$@" --cwd-file="$tmp"

  if cwd="$(cat "$tmp" 2>/dev/null)" &&
     [ -n "$cwd" ] &&
     [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi

  rm -f -- "$tmp"
}

# --- Default terminal editor ----------------------------------------------
export EDITOR="micro"
export VISUAL="micro"


# =============================================================================
# CMUX MARKDOWN TOOLKIT
# =============================================================================

alias mdp="cmux-md preview"
alias mdr="cmux-md review"
alias mdb="cmux-md both"

export PATH=$PATH:$(go env GOPATH)/bin
