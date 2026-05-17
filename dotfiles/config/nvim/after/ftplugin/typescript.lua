local map = vim.keymap.set
local opts = { buffer = true }

map("n", "gD", function() require("vtsls").commands.goto_source_definition(0) end, vim.tbl_extend("force", opts, { desc = "Source definition" }))
map("n", "<leader>co", function() require("vtsls").commands.organize_imports(0) end, vim.tbl_extend("force", opts, { desc = "Organize imports" }))
map("n", "<leader>cu", function() require("vtsls").commands.remove_unused_imports(0) end, vim.tbl_extend("force", opts, { desc = "Remove unused imports" }))
map("n", "<leader>cm", function() require("vtsls").commands.add_missing_imports(0) end, vim.tbl_extend("force", opts, { desc = "Add missing imports" }))
map("n", "<leader>cF", function() require("vtsls").commands.fix_all(0) end, vim.tbl_extend("force", opts, { desc = "Fix all" }))
