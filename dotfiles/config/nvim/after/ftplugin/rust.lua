local map = vim.keymap.set
local opts = { buffer = true }

-- rustaceanvim keymaps
map("n", "K", function() vim.cmd.RustLsp({ "hover", "actions" }) end, vim.tbl_extend("force", opts, { desc = "Rust hover" }))
map("n", "J", function() vim.cmd.RustLsp("joinLines") end, vim.tbl_extend("force", opts, { desc = "Rust join lines" }))

map("n", "<leader>rr", function() vim.cmd.RustLsp("runnables") end, vim.tbl_extend("force", opts, { desc = "Runnables" }))
map("n", "<leader>rt", function() vim.cmd.RustLsp("testables") end, vim.tbl_extend("force", opts, { desc = "Testables" }))
map("n", "<leader>rd", function() vim.cmd.RustLsp("debuggables") end, vim.tbl_extend("force", opts, { desc = "Debuggables" }))
map("n", "<leader>re", function() vim.cmd.RustLsp("expandMacro") end, vim.tbl_extend("force", opts, { desc = "Expand macro" }))
map("n", "<leader>rx", function() vim.cmd.RustLsp("explainError") end, vim.tbl_extend("force", opts, { desc = "Explain error" }))
map("n", "<leader>rc", function() vim.cmd.RustLsp("openCargo") end, vim.tbl_extend("force", opts, { desc = "Open Cargo.toml" }))
map("n", "<leader>ro", function() vim.cmd.RustLsp("openDocs") end, vim.tbl_extend("force", opts, { desc = "Open docs.rs" }))
map("n", "<leader>rp", function() vim.cmd.RustLsp("parentModule") end, vim.tbl_extend("force", opts, { desc = "Parent module" }))
