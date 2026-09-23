# Cmux Development Environment

This repo backs up the terminal-first development environment on macOS and makes it reproducible.

Main goals:

- Workspace / pane management with cmux
- Claude Code + Codex agent workflow
- Browser debugging
- Worktree-based isolated development
- User-space CLI tools
- A clean and portable shell experience
- Git / file management TUI tools
- Config backup + restore
- Health / security / version checks

> This setup is designed with a company-managed Mac in mind.
> No ownership / permission changes are made to Homebrew directories, and user-space installs under `~/.local` are used wherever possible.

---

## Current cmux baseline

Currently tested cmux build:

```text
cmux 0.64.22 (102) [ddd4a01bc]
```

The schema in both the global and project-local cmux configs is pinned to this build:

```jsonc
"$schema": "https://raw.githubusercontent.com/manaflow-ai/cmux/ddd4a01bc/web/data/cmux.schema.json"
```

The `main` branch schema is not used.

After every cmux update, always run:

```bash
cmux-version-check
cmux-health
```

---

# Stack

## Terminal / Workspace

```text
cmux
Ghostty config
Catppuccin Mocha
JetBrains Mono
```

## Shell

```text
zsh
Oh My Zsh
zsh-autosuggestions
zsh-syntax-highlighting
Starship
zoxide
fzf
```

## CLI tools

```text
rg          ripgrep
fd          fast file search
bat         cat replacement
fzf         fuzzy finder
zoxide      smart cd
lazygit     Git TUI
yazi        file manager TUI
micro       terminal editor
```

## Agents

```text
Claude Code
Codex CLI
Claude Teams
Codex Teams
```

---

# Directory layout

```text
~/.dotfiles/
├── README.md
├── install.sh
├── sync.sh
├── zshrc
│
├── config/
│   ├── cmux/
│   │   ├── cmux.json
│   │   ├── dock.json
│   │   └── templates/
│   │
│   ├── ghostty/
│   │   └── config
│   │
│   ├── starship/
│   │   └── starship.toml
│   │
│   ├── micro/
│   │   ├── settings.json
│   │   └── colorschemes/
│   │       └── catppuccin-mocha.micro
│   │
│   └── yazi/
│       ├── yazi.toml
│       ├── theme.toml
│       ├── keymap.toml
│       └── package.toml
│
├── hooks/
│   └── pre-commit
│
└── scripts/
    ├── cmux-init
    ├── cmux-wt-clean
    ├── cmux-health
    ├── cmux-secrets-check
    ├── cmux-browser-debug
    ├── cmux-ports
    ├── cmux-version-check
    ├── cmux-dev
    └── cmux-agents
```

---

# Shell shortcuts

## Micro

Default terminal editor:

```bash
m file.txt
```

Equivalent:

```bash
micro file.txt
```

Environment:

```bash
EDITOR=micro
VISUAL=micro
```

Micro basics:

```text
Ctrl+S    save
Ctrl+Q    quit
Ctrl+F    search
Ctrl+Z    undo
Ctrl+Y    redo
```

Micro uses the Catppuccin Mocha theme.

---

## Lazygit

Open inside any Git repository:

```bash
lg
```

Equivalent:

```bash
lazygit
```

Useful keys:

```text
j / k     move
h / l     switch panels
Space     stage / unstage
c         commit
p         push
P         pull
s         stash
Enter     open/details
?         help for current panel
q         back/quit
```

---

## Yazi

Start file manager:

```bash
y
```

Use `y`, not only `yazi`, when possible.

The `y` wrapper changes the shell directory to the last directory visited in Yazi after quitting.

Basic keys:

```text
j / k       move
h           parent directory
l / Enter   open
Space       select
y           copy
x           cut
p           paste
r           rename
d           delete
.           toggle hidden files
g f         flat file view
?           help
q           quit
```

Text/code files open with Micro.

---

## Markdown Preview & Review

This setup includes a small Markdown workflow for cmux.

```bash
mdp README.md
```

Opens the file in cmux's native Markdown preview with live reload.

```bash
mdr README.md
```

Runs Markdown linting and shows the Git status plus staged and unstaged diffs for the file.

```bash
mdb README.md
```

Runs both preview and review.

Auto-fix supported lint issues with:

```bash
cmux-md fix README.md
```

Main components:

```text
cmux native Markdown viewer
markdownlint-cli2
cmux-md helper
```

---

# cmux everyday commands

## Command palette

```text
Cmd+Shift+P
```

Used for:

```text
Project Dev
Multi Agent Dev
Claude Team
custom cmux commands
```

## Workspace switch

```text
Cmd+P
```

## Pane management

```text
Cmd+D            split right
Cmd+Shift+D      split down
Cmd+W            close
Cmd+Shift+Enter  zoom pane
Cmd+B            toggle sidebar
```

## Pane focus

```text
Option+Cmd+H    left
Option+Cmd+J    down
Option+Cmd+K    up
Option+Cmd+L    right
```

---

# Project Dev

Repo-local cmux config lives at:

```text
.cmux/cmux.json
```

Normal Project Dev layout:

```text
Claude + Server + Browser + Shell
```

The Shell remains a general-purpose terminal.

Use Micro only when needed:

```bash
m file
```

Use Lazygit when needed:

```bash
lg
```

Use Yazi when needed:

```bash
y
```

---

# Multi Agent Dev

Launcher:

```text
Cmd+Shift+P
-> Multi Agent Dev
```

Recommended usage:

```text
Claude -> main implementation / refactor
Codex  -> review / second opinion / bug analysis
```

Avoid letting two agents modify the same checkout independently.

For parallel implementation work, use separate Git worktrees.

---

# Claude statusline

Claude Code statusline is configured to show available information such as:

```text
model
context remaining
usage
session cost
branch
```

Inside Claude:

```text
/context
```

shows detailed context usage.

```text
/usage
```

shows account/rate-limit usage when available.

---

# Agent Cockpit

Main command:

```bash
cmux-agents
```

Direct commands:

```bash
cmux-agents status
cmux-agents feed
cmux-agents notifications
cmux-agents tree
cmux-agents top
cmux-agents events
cmux-agents browser
cmux-agents claude-teams
cmux-agents codex-teams
cmux-agents capabilities
```

## Status

```bash
cmux-agents status
```

Shows:

```text
current repo
current branch
cmux version
Claude version
Codex version
detected agent surfaces
```

## Feed

```bash
cmux-agents feed
```

Opens agent/feed activity TUI.

## Live events

```bash
cmux-agents events
```

Shows cmux event stream.

## Runtime capabilities

```bash
cmux-agents capabilities
```

Useful after cmux updates because not every build exposes exactly the same runtime features.

---

# Dock

Dock is an optional persistent right-side cmux control area.

Config:

```text
~/.config/cmux/dock.json
```

Current intended Dock widgets:

```text
Feed
Agent Events
```

Open Dock when supported by the current runtime:

```bash
cmux right-sidebar dock
```

Runtime support can vary between cmux builds.

Check:

```bash
cmux capabilities
```

---

# Dev Control

Main command:

```bash
cmux-dev
```

Direct commands:

```bash
cmux-dev health
cmux-dev ports
cmux-dev ports who 3000
cmux-dev ports free
cmux-dev browser
cmux-dev worktrees
cmux-dev version
cmux-dev secrets
```

---

# Health check

Run:

```bash
cmux-health
```

Checks:

```text
cmux
cmux config doctor
Claude
Codex
Node
/bin/sh Node visibility
NVM
fzf
rg
fd
bat
starship
zoxide
zsh plugins
helper scripts
dotfiles
prompt
```

Healthy environment should end with:

```text
FAIL : 0
 
Environment looks healthy.
```

---

# Version / schema check

Run:

```bash
cmux-version-check
```

Checks:

```text
installed cmux version
installed build commit
global cmux schema
project-local cmux schema
schemaVersion
cmux config doctor
```

Run this after every cmux update.

---

# Browser debugging

Run:

```bash
cmux-browser-debug
```

The script automatically finds browser surfaces.

If multiple browsers exist, `fzf` is used to select one.

Manual target:

```bash
cmux-browser-debug surface:44
```

The debug bundle contains:

```text
page.txt
snapshot.txt
console.txt
errors.txt
screenshot.png
```

Stored under:

```text
/tmp/cmux-browser-debug-<timestamp>/
```

---

# Port / process management

Main command:

```bash
cmux-ports
```

List listeners:

```bash
cmux-ports
```

Find process using a port:

```bash
cmux-ports who 3000
```

Find first available port:

```bash
cmux-ports free
```

Custom range:

```bash
cmux-ports free 3000 3099
```

Safely stop a user-owned process:

```bash
cmux-ports kill 3000
```

---

# Git worktrees

List worktrees:

```bash
wt
```

Clean up a worktree:

```bash
wtc
```

Dry-run prune:

```bash
wtprune
```

`cmux-wt-clean` refuses to remove dirty worktrees.

---

# Project templates

Initialize a repo-local cmux config:

```bash
cmux-init web
```

Other templates:

```bash
cmux-init backend
cmux-init monorepo
```

Generated file:

```text
<repo>/.cmux/cmux.json
```

Project-local config should contain:

```text
project layout
dev server command
browser URL
project-specific commands
```

It should NOT contain:

```text
tokens
API keys
credentials
personal secrets
```

---

# Secrets

Scan staged files:

```bash
cmux-secrets-check
```

The dotfiles repo has a pre-commit hook that runs this automatically.

Never commit:

```text
.env
private keys
SSH credentials
AWS credentials
Claude authentication/session data
npm tokens
API tokens
```

---

# cmux config validation

Validate:

```bash
cmux config doctor
```

Reload config:

```bash
cmux reload-config
```

Version:

```bash
cmux --version
```

Capabilities:

```bash
cmux capabilities
```

---

# Claude Teams

Launch:

```bash
cmux claude-teams
```

Recommended review prompt:

```text
Inspect the code only.
Do not modify files.
Report findings first and wait for approval.
```

---

# Codex Teams

Launch:

```bash
cmux codex-teams
```

Codex is also available in Multi Agent Dev.

---

# Shell tools

## ripgrep

```bash
rg "search"
```

## fd

```bash
fd filename
```

## bat

```bash
bat file.txt
```

## zoxide

```bash
z project
```

---

# Dotfiles workflow

After changing configs:

```bash
~/.dotfiles/sync.sh
```

Then inspect:

```bash
cd ~/.dotfiles
git status
git diff
```

Commit:

```bash
git add .
git commit -m "Update development environment"
```

Push:

```bash
git push
```

Recommended flow:

```text
change live config
-> sync.sh
-> git diff
-> commit
-> push
```

---

# Install on another Mac

Clone the private repo:

```bash
git clone <PRIVATE_DOTFILES_REPO_URL> ~/.dotfiles
```

Make installer executable:

```bash
chmod 755 ~/.dotfiles/install.sh
```

Install:

```bash
~/.dotfiles/install.sh
```

Reload shell:

```bash
exec zsh
```

Then validate:

```bash
cmux-health
cmux-version-check
```

Also verify:

```bash
micro --version
lazygit --version
yazi --version
fzf --version
rg --version
fd --version
bat --version
starship --version
zoxide --version
```

After installing/updating cmux:

```bash
cmux --version
cmux capabilities
cmux-version-check
cmux-health
```

---

# Update cmux safely

Before update:

```bash
cmux-version-check
~/.dotfiles/sync.sh
```

After update:

```bash
cmux --version
cmux-version-check
cmux config doctor
cmux-health
```

If the build commit changed, update `$schema` to the new build commit.

Example:

```jsonc
"$schema": "https://raw.githubusercontent.com/manaflow-ai/cmux/<BUILD_COMMIT>/web/data/cmux.schema.json"
```

Then:

```bash
cmux reload-config
cmux config doctor
```

---

# Useful quick reference

```bash
# Main control centers
cmux-dev
cmux-agents
 
# Terminal tools
m <file>
lg
y
 
# Diagnostics
cmux-health
cmux-version-check
cmux capabilities
 
# Browser
cmux-browser-debug
 
# Ports
cmux-ports
cmux-ports who 3000
cmux-ports free
 
# Worktrees
wt
wtc
wtprune
 
# Security
cmux-secrets-check
 
# Project setup
cmux-init web
 
# Agents
cmux claude-teams
cmux codex-teams
 
# cmux
cmux tree
cmux top
cmux config doctor
cmux reload-config
 
# Dotfiles
~/.dotfiles/sync.sh
```

---

# Design principles

```text
Prefer user-space installs.
Avoid sudo/Homebrew ownership hacks.
Keep cmux layouts useful, not decorative.
Keep Shell panes general-purpose.
Use Micro only when editing is needed.
Use Lazygit only when Git UI is useful.
Use Yazi only when file navigation is useful.
Use worktrees for parallel implementation agents.
Keep secrets out of configs and Git.
Pin cmux schema to the installed build.
Do not assume every cmux build exposes the same runtime capabilities.
```

The goal is a small set of composable tools:

```text
cmux       workspace
Claude     primary coding agent
Codex      second agent / review
Shell      general control
Browser    runtime/debug
Micro      quick editing
Lazygit    Git
Yazi       filesystem
```
