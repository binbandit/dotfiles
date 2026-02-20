local map = vim.keymap.set
local opts = { silent = true, buffer = true }

local function merge(extra)
  return vim.tbl_extend("keep", extra, opts)
end

-- Override K with hover actions (shows runnable actions in hover popup)
map("n", "K", function()
  vim.cmd.RustLsp({ "hover", "actions" })
end, merge({ desc = "Rust hover actions" }))

-- Code action (grouped, Rust-specific)
map("n", "<leader>ca", function()
  vim.cmd.RustLsp("codeAction")
end, merge({ desc = "Rust code action" }))

-- Run
map("n", "<leader>rr", function()
  vim.cmd.RustLsp("runnables")
end, merge({ desc = "Runnables" }))

map("n", "<leader>rl", function()
  vim.cmd.RustLsp({ "runnables", bang = true })
end, merge({ desc = "Rerun last runnable" }))

-- Test
map("n", "<leader>rt", function()
  vim.cmd.RustLsp("testables")
end, merge({ desc = "Testables" }))

-- Debug
map("n", "<leader>rd", function()
  vim.cmd.RustLsp("debuggables")
end, merge({ desc = "Debuggables" }))

-- Expand macro
map("n", "<leader>re", function()
  vim.cmd.RustLsp("expandMacro")
end, merge({ desc = "Expand macro" }))

-- Join lines (Rust-aware, handles trailing commas etc.)
map("n", "J", function()
  vim.cmd.RustLsp("joinLines")
end, merge({ desc = "Rust join lines" }))

-- Explain error under cursor
map("n", "<leader>rx", function()
  vim.cmd.RustLsp("explainError")
end, merge({ desc = "Explain error" }))

-- Render diagnostic (full diagnostic with suggestion)
map("n", "<leader>rD", function()
  vim.cmd.RustLsp("renderDiagnostic")
end, merge({ desc = "Render diagnostic" }))

-- Open Cargo.toml
map("n", "<leader>rc", function()
  vim.cmd.RustLsp("openCargo")
end, merge({ desc = "Open Cargo.toml" }))

-- Open docs.rs for item under cursor
map("n", "<leader>ro", function()
  vim.cmd.RustLsp("openDocs")
end, merge({ desc = "Open docs.rs" }))

-- Parent module
map("n", "<leader>rp", function()
  vim.cmd.RustLsp("parentModule")
end, merge({ desc = "Parent module" }))

-- Related tests
map("n", "<leader>rT", function()
  vim.cmd.RustLsp("relatedTests")
end, merge({ desc = "Related tests" }))

-- Move item up/down
map("n", "<A-k>", function()
  vim.cmd.RustLsp({ "moveItem", "up" })
end, merge({ desc = "Move item up" }))

map("n", "<A-j>", function()
  vim.cmd.RustLsp({ "moveItem", "down" })
end, merge({ desc = "Move item down" }))

-- Rebuild proc macros
map("n", "<leader>rR", function()
  vim.cmd.RustLsp("rebuildProcMacros")
end, merge({ desc = "Rebuild proc macros" }))

-- Fly check (trigger cargo check/clippy manually)
map("n", "<leader>rf", function()
  vim.cmd.RustLsp("flyCheck")
end, merge({ desc = "Fly check (clippy)" }))

-- Crate graph (visual dependency graph)
map("n", "<leader>rg", function()
  vim.cmd.RustLsp("crateGraph")
end, merge({ desc = "Crate graph" }))

-- SSR (structural search and replace)
map("n", "<leader>rs", function()
  vim.cmd.RustLsp("ssr")
end, merge({ desc = "Structural search replace" }))
