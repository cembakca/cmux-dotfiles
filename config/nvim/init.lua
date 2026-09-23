-- =============================================================================
-- NEOVIM
-- =============================================================================

-- Leader key'i plugin/keymap'lerden once tanimla.
vim.g.mapleader = " "
vim.g.maplocalleader = " "


-- =============================================================================
-- EDITOR
-- =============================================================================

local opt = vim.opt

-- Satir numaralari.
opt.number = true
opt.relativenumber = true

-- Mouse terminal icinde kullanilabilsin.
opt.mouse = "a"

-- Sistem clipboard'u ile entegre ol.
opt.clipboard = "unnamedplus"

-- Indentation.
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true

-- Uzun satirlari wrap etme.
opt.wrap = false

-- Arama.
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

-- UI.
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Split davranisi.
opt.splitright = true
opt.splitbelow = true

-- Daha hizli UI/plugin feedback.
opt.updatetime = 250
opt.timeoutlen = 400

-- Undo restart sonrasi da korunsun.
opt.undofile = true

-- Swap dosyasi istemiyoruz.
opt.swapfile = false


-- =============================================================================
-- KEYMAPS
-- =============================================================================

local map = vim.keymap.set

-- Dosyayi kaydet.
map("n", "<leader>w", "<cmd>write<cr>", {
  desc = "Save file"
})

-- Pane/split navigation.
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Search highlight temizle.
map("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- Visual modda secili satirlari tasirken indentation koru.
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")


-- =============================================================================
-- DIAGNOSTICS
-- =============================================================================

vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  signs = true,
  severity_sort = true,

  float = {
    border = "rounded",
  },
})
