#!/bin/zsh

set -e

DOTFILES="$HOME/.dotfiles"

echo "Syncing dotfiles..."


# =============================================================================
# DIRECTORIES
# =============================================================================

mkdir -p "$DOTFILES/config/cmux"
mkdir -p "$DOTFILES/config/ghostty"
mkdir -p "$DOTFILES/config/starship"
mkdir -p "$DOTFILES/config/micro/colorschemes"
mkdir -p "$DOTFILES/config/yazi"
mkdir -p "$DOTFILES/scripts"


# =============================================================================
# CMUX
# =============================================================================

cp "$HOME/.config/cmux/cmux.json" \
   "$DOTFILES/config/cmux/cmux.json"

if [ -d "$HOME/.config/cmux/templates" ]; then
  rm -rf "$DOTFILES/config/cmux/templates"

  cp -R "$HOME/.config/cmux/templates" \
        "$DOTFILES/config/cmux/templates"
fi

if [ -f "$HOME/.config/cmux/dock.json" ]; then
  cp "$HOME/.config/cmux/dock.json" \
     "$DOTFILES/config/cmux/dock.json"
fi


# =============================================================================
# GHOSTTY
# =============================================================================

cp "$HOME/.config/ghostty/config" \
   "$DOTFILES/config/ghostty/config"


# =============================================================================
# STARSHIP
# =============================================================================

cp "$HOME/.config/starship.toml" \
   "$DOTFILES/config/starship/starship.toml"


# =============================================================================
# ZSH
# =============================================================================

cp "$HOME/.zshrc" \
   "$DOTFILES/zshrc"


# =============================================================================
# MICRO
# =============================================================================

if [ -f "$HOME/.config/micro/settings.json" ]; then
  cp "$HOME/.config/micro/settings.json" \
     "$DOTFILES/config/micro/settings.json"
fi

if [ -f "$HOME/.config/micro/colorschemes/catppuccin-mocha.micro" ]; then
  cp "$HOME/.config/micro/colorschemes/catppuccin-mocha.micro" \
     "$DOTFILES/config/micro/colorschemes/catppuccin-mocha.micro"
fi


# =============================================================================
# YAZI
# =============================================================================

for file in yazi.toml theme.toml keymap.toml package.toml; do
  if [ -f "$HOME/.config/yazi/$file" ]; then
    cp "$HOME/.config/yazi/$file" \
       "$DOTFILES/config/yazi/$file"
  fi
done


# =============================================================================
# HELPER SCRIPTS
# =============================================================================

helpers=(
  cmux-init
  cmux-wt-clean
  cmux-health
  cmux-secrets-check
  cmux-browser-debug
  cmux-ports
  cmux-version-check
  cmux-dev
  cmux-agents
)

for helper in "${helpers[@]}"; do
  if [ -f "$HOME/.local/bin/$helper" ]; then
    cp "$HOME/.local/bin/$helper" \
       "$DOTFILES/scripts/$helper"

    chmod 755 "$DOTFILES/scripts/$helper"
  fi
done


# =============================================================================
# DONE
# =============================================================================

echo
echo "Dotfiles synced."
echo

cd "$DOTFILES"
git status --short
