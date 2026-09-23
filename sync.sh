#!/bin/zsh

set -e

DOTFILES="$HOME/.dotfiles"

echo "Syncing dotfiles..."

# cmux global config
cp "$HOME/.config/cmux/cmux.json" \
   "$DOTFILES/config/cmux/cmux.json"

# cmux project templates
rm -rf "$DOTFILES/config/cmux/templates"
cp -R "$HOME/.config/cmux/templates" \
      "$DOTFILES/config/cmux/templates"

# Ghostty / terminal appearance
cp "$HOME/.config/ghostty/config" \
   "$DOTFILES/config/ghostty/config"

# Starship prompt
cp "$HOME/.config/starship.toml" \
   "$DOTFILES/config/starship/starship.toml"

# Zsh
cp "$HOME/.zshrc" \
   "$DOTFILES/zshrc"

# Our helper scripts
cp "$HOME/.local/bin/cmux-init" \
   "$DOTFILES/scripts/cmux-init"

cp "$HOME/.local/bin/cmux-wt-clean" \
   "$DOTFILES/scripts/cmux-wt-clean"

cp "$HOME/.local/bin/cmux-health" \
   "$DOTFILES/scripts/cmux-health"

cp "$HOME/.local/bin/cmux-secrets-check" \
   "$DOTFILES/scripts/cmux-secrets-check"

cp "$HOME/.local/bin/cmux-browser-debug" \
   "$DOTFILES/scripts/cmux-browser-debug"

cp "$HOME/.local/bin/cmux-version-check" \
   "$DOTFILES/scripts/cmux-version-check"

cp "$HOME/.local/bin/cmux-dev" \
   "$DOTFILES/scripts/cmux-dev"

chmod 755 "$DOTFILES/scripts/cmux-init"
chmod 755 "$DOTFILES/scripts/cmux-wt-clean"

echo
echo "Dotfiles synced."
echo

cd "$DOTFILES"
git status --short
