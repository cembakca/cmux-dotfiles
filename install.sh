cat > ~/.dotfiles/install.sh <<'EOF'
#!/bin/zsh

set -e

DOTFILES="$HOME/.dotfiles"
BIN_DIR="$HOME/.local/bin"

echo
echo "========================================"
echo " Installing development environment"
echo "========================================"
echo


# =============================================================================
# PREREQUISITES
# =============================================================================

# Sistem package manager kullanmiyoruz.
# Ancak macOS'ta git ve curl mevcut olmali.
for cmd in git curl; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Required command not found: $cmd"
    exit 1
  fi
done


# =============================================================================
# DIRECTORIES
# =============================================================================

mkdir -p "$HOME/.config/cmux"
mkdir -p "$HOME/.config/ghostty"
mkdir -p "$HOME/.config/starship"
mkdir -p "$HOME/.zsh/plugins"
mkdir -p "$BIN_DIR"

# User-space binary'leri bu script calisirken de PATH'te olsun.
export PATH="$BIN_DIR:$PATH"


# =============================================================================
# SHELL DEPENDENCIES
# =============================================================================


# --- Oh My Zsh ------------------------------------------------------------

# .zshrc Oh My Zsh kullaniyor.
#
# RUNZSH=no:
# Installer bittikten sonra otomatik shell acma.
#
# CHSH=no:
# Sirket makinesinde login shell'i degistirmeye calisma.
#
# KEEP_ZSHRC=yes:
# Version-controlled .zshrc dosyamizi koru.
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."

  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL \
      https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "Oh My Zsh already installed."
fi


# --- zsh-autosuggestions --------------------------------------------------

# History tabanli inline command onerileri.
if [ ! -d "$HOME/.zsh/plugins/zsh-autosuggestions/.git" ]; then
  echo "Installing zsh-autosuggestions..."

  git clone \
    https://github.com/zsh-users/zsh-autosuggestions \
    "$HOME/.zsh/plugins/zsh-autosuggestions"
else
  echo "zsh-autosuggestions already installed."
fi


# --- zsh-syntax-highlighting ----------------------------------------------

# Komutlari yazarken syntax durumunu renklendirir.
if [ ! -d "$HOME/.zsh/plugins/zsh-syntax-highlighting/.git" ]; then
  echo "Installing zsh-syntax-highlighting..."

  git clone \
    https://github.com/zsh-users/zsh-syntax-highlighting \
    "$HOME/.zsh/plugins/zsh-syntax-highlighting"
else
  echo "zsh-syntax-highlighting already installed."
fi


# =============================================================================
# USER-SPACE CLI TOOLS
# =============================================================================


# --- Architecture ---------------------------------------------------------

case "$(uname -m)" in
  arm64)
    DARWIN_TARGET="aarch64-apple-darwin"
    ;;
  x86_64)
    DARWIN_TARGET="x86_64-apple-darwin"
    ;;
  *)
    echo "Unsupported architecture: $(uname -m)"
    exit 1
    ;;
esac


# --- fzf ------------------------------------------------------------------

# Fuzzy history / file search.
if [ ! -d "$HOME/.fzf/.git" ]; then
  echo "Installing fzf..."

  git clone --depth 1 \
    https://github.com/junegunn/fzf.git \
    "$HOME/.fzf"

  "$HOME/.fzf/install" --bin
else
  echo "fzf already installed."
fi

# ~/.local/bin uzerinden her zaman erisilebilir olsun.
if [ -x "$HOME/.fzf/bin/fzf" ]; then
  ln -sf "$HOME/.fzf/bin/fzf" "$BIN_DIR/fzf"
fi


# --- Starship -------------------------------------------------------------

# Minimal shell prompt.
if ! command -v starship >/dev/null 2>&1; then
  echo "Installing Starship..."

  curl -sS https://starship.rs/install.sh |
    sh -s -- -b "$BIN_DIR" -y
else
  echo "Starship already installed."
fi


# --- zoxide ---------------------------------------------------------------

# Akilli directory navigation.
if ! command -v zoxide >/dev/null 2>&1; then
  echo "Installing zoxide..."

  curl -sSfL \
    https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh |
    sh
else
  echo "zoxide already installed."
fi


# --- GitHub binary installer ----------------------------------------------

# GitHub latest release'indeki macOS binary paketlerinden
# CLI araclarini ~/.local/bin altina kurar.
install_github_binary() {
  repo="$1"
  binary="$2"

  if command -v "$binary" >/dev/null 2>&1; then
    echo "$binary already installed."
    return 0
  fi

  echo "Installing $binary..."

  tmp="$(mktemp -d)"

  url="$(
    curl -fsSL "https://api.github.com/repos/$repo/releases/latest" |
      sed -n 's/.*"browser_download_url": "\(.*\)".*/\1/p' |
      grep "$DARWIN_TARGET.*\.tar\.gz$" |
      grep -v -E '\.(sha256|sig|asc)$' |
      head -n 1
  )"

  if [ -z "$url" ]; then
    echo "Could not find macOS release for $repo"
    rm -rf "$tmp"
    return 1
  fi

  curl -fL "$url" -o "$tmp/package.tar.gz"

  tar -xzf "$tmp/package.tar.gz" -C "$tmp"

  bin_path="$(
    find "$tmp" -type f -name "$binary" |
      head -n 1
  )"

  if [ -z "$bin_path" ]; then
    echo "Could not find $binary inside archive"
    rm -rf "$tmp"
    return 1
  fi

  cp "$bin_path" "$BIN_DIR/$binary"
  chmod 755 "$BIN_DIR/$binary"

  rm -rf "$tmp"

  echo "$binary installed."
}


# Hizli code/text search.
install_github_binary \
  BurntSushi/ripgrep \
  rg

# Hizli file search.
install_github_binary \
  sharkdp/fd \
  fd

# Syntax-highlighted cat alternatifi.
install_github_binary \
  sharkdp/bat \
  bat


# =============================================================================
# DOTFILES
# =============================================================================

echo
echo "Installing config files..."


# --- cmux -----------------------------------------------------------------

cp \
  "$DOTFILES/config/cmux/cmux.json" \
  "$HOME/.config/cmux/cmux.json"

rm -rf "$HOME/.config/cmux/templates"

cp -R \
  "$DOTFILES/config/cmux/templates" \
  "$HOME/.config/cmux/templates"


# --- Ghostty / cmux terminal ----------------------------------------------

cp \
  "$DOTFILES/config/ghostty/config" \
  "$HOME/.config/ghostty/config"


# --- Starship -------------------------------------------------------------

cp \
  "$DOTFILES/config/starship/starship.toml" \
  "$HOME/.config/starship.toml"


# --- Zsh ------------------------------------------------------------------

cp \
  "$DOTFILES/zshrc" \
  "$HOME/.zshrc"


# =============================================================================
# HELPER SCRIPTS
# =============================================================================

cp \
  "$DOTFILES/scripts/cmux-init" \
  "$BIN_DIR/cmux-init"

cp \
  "$DOTFILES/scripts/cmux-wt-clean" \
  "$BIN_DIR/cmux-wt-clean"

cp \
  "$DOTFILES/scripts/cmux-health" \
  "$BIN_DIR/cmux-health"

cp \
  "$DOTFILES/scripts/cmux-secrets-check" \
  "$BIN_DIR/cmux-secrets-check"

cp \
  "$DOTFILES/scripts/cmux-browser-debug" \
  "$BIN_DIR/cmux-browser-debug"

cp \
  "$DOTFILES/scripts/cmux-ports" \
  "$BIN_DIR/cmux-ports"

cp \
  "$DOTFILES/scripts/cmux-version-check" \
  "$BIN_DIR/cmux-version-check"

cp \
  "$DOTFILES/scripts/cmux-dev" \
  "$BIN_DIR/cmux-dev"

chmod 755 "$BIN_DIR/cmux-init"
chmod 755 "$BIN_DIR/cmux-wt-clean"
chmod 755 "$BIN_DIR/cmux-health"
chmod 755 "$BIN_DIR/cmux-secrets-check"
chmod 755 "$BIN_DIR/cmux-browser-debug"
chmod 755 "$BIN_DIR/cmux-ports"
chmod 755 "$BIN_DIR/cmux-version-check"
chmod 755 "$BIN_DIR/cmux-dev"


# =============================================================================
# GIT SECURITY HOOK
# =============================================================================

# Dotfiles repo'sunda her commit'ten once secret scanner calissin.
#
# Hook'un kendisi repo icinde version-controlled:
#   ~/.dotfiles/hooks/pre-commit
#
# Git'in kullandigi yere symlink olusturuyoruz:
#   ~/.dotfiles/.git/hooks/pre-commit
if [ -d "$DOTFILES/.git" ]; then
  if [ -f "$DOTFILES/hooks/pre-commit" ]; then
    chmod 755 "$DOTFILES/hooks/pre-commit"

    ln -sf \
      "$DOTFILES/hooks/pre-commit" \
      "$DOTFILES/.git/hooks/pre-commit"

    echo "Dotfiles pre-commit security hook installed."
  else
    echo "WARNING: $DOTFILES/hooks/pre-commit not found."
  fi
fi


# =============================================================================
# VERIFY
# =============================================================================

echo
echo "Checking installed tools..."
echo

for cmd in git fzf rg fd bat starship zoxide; do
  printf "%-20s " "$cmd"

  if command -v "$cmd" >/dev/null 2>&1; then
    echo "OK"
  else
    echo "MISSING"
  fi
done

echo
echo "Checking helper scripts..."
echo

for cmd in cmux-init cmux-wt-clean cmux-health cmux-secrets-check; do
  printf "%-20s " "$cmd"

  if command -v "$cmd" >/dev/null 2>&1; then
    echo "OK"
  else
    echo "MISSING"
  fi
done


# =============================================================================
# DONE
# =============================================================================

echo
echo "========================================"
echo " Dotfiles installed successfully"
echo "========================================"
echo
echo "Reload shell with:"
echo
echo "  exec zsh"
echo
EOF

chmod 755 ~/.dotfiles/install.sh