-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Add Ctrl+S to save files in all modes
vim.keymap.set({ "n", "i", "v", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Add Cmd+S to save files in all modes (macOS)
vim.keymap.set({ "n", "i", "v", "s" }, "<D-s>", "<cmd>w<cr><esc>", { desc = "Save file (macOS)" })

-- Add a keymap to show all available commands
vim.keymap.set("n", "<leader>fc", function() require("fzf-lua").commands() end, { desc = "Find Commands" })
vim.keymap.set("n", "<leader>?", function() require("fzf-lua").commands() end, { desc = "Search Commands" })
vim.keymap.set("n", "<leader>C", "<cmd>Commands<cr>", { desc = "List All Commands" })

-- Add a global keymap for quick access to LazyGit
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })

-- Add Ctrl+A to select all text
vim.keymap.set("n", "<C-a>", "ggVG", { desc = "Select all text" })
vim.keymap.set("i", "<C-a>", "<Esc>ggVG", { desc = "Exit insert mode and select all text" })

-- Add Ctrl+= and Ctrl+- for increment/decrement
vim.keymap.set("n", "<C-=>", function() require("dial.map").inc_normal() end, { desc = "Increment" })
vim.keymap.set("n", "<C-->", function() require("dial.map").dec_normal() end, { desc = "Decrement" })

-- Add handy redo shortcut (Ctrl+Y for redo, complementing the default Ctrl+R which can conflict with other mappings)
vim.keymap.set("n", "<C-y>", "<C-r>", { desc = "Redo" })
vim.keymap.set("n", "<C-r>", "<C-r>", { desc = "Redo" }) -- Keep the default binding too

-- Add keyboard shortcuts for splitting windows
-- Note: <C-w>v and <C-w>s are already the default Vim keybindings
-- Adding more accessible shortcuts
vim.keymap.set("n", "<C-x>v", "<cmd>vsplit<cr>", { desc = "Split window vertically" })
vim.keymap.set("n", "<C-x>s", "<cmd>split<cr>", { desc = "Split window horizontally" })

-- Comprehensive code navigation keybindings with 'g' prefix
-- Go to definition/declaration/implementation
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { desc = "Go to Type Definition" })

-- References and symbols
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find References" })
vim.keymap.set("n", "gs", vim.lsp.buf.document_symbol, { desc = "Document Symbols" })
vim.keymap.set("n", "gS", vim.lsp.buf.workspace_symbol, { desc = "Workspace Symbols" })

-- Diagnostics navigation
vim.keymap.set("n", "gn", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
vim.keymap.set("n", "gp", vim.diagnostic.goto_prev, { desc = "Previous Diagnostic" })
vim.keymap.set("n", "ge", vim.diagnostic.open_float, { desc = "Show Diagnostic Details" })

-- Documentation and help
vim.keymap.set("n", "gk", vim.lsp.buf.hover, { desc = "Show Hover Documentation" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show Hover Documentation" }) -- Keep K for backward compatibility
vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })

-- Code actions and modifications
vim.keymap.set("n", "ga", vim.lsp.buf.code_action, { desc = "Code Actions" })
vim.keymap.set("v", "ga", vim.lsp.buf.code_action, { desc = "Code Actions" }) -- Also in visual mode
vim.keymap.set("n", "gR", vim.lsp.buf.rename, { desc = "Rename Symbol" })
vim.keymap.set("n", "gf", function() vim.lsp.buf.format({ async = true }) end, { desc = "Format Code" })
vim.keymap.set("v", "gf", function() vim.lsp.buf.format({ async = true }) end, { desc = "Format Selection" }) -- Also in visual mode
vim.keymap.set("n", "gl", vim.lsp.codelens.run, { desc = "Run CodeLens" })

-- Toggle inlay hints (if available)
if vim.lsp.inlay_hint then
  vim.keymap.set("n", "gh", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end, { desc = "Toggle Inlay Hints" })
end
