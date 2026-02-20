local M = {}

function M.setup()
  local map = vim.keymap.set
  local opts = { silent = true, buffer = true }

  local function o(desc)
    return vim.tbl_extend("keep", { desc = desc }, opts)
  end

  -- Go to source definition (not .d.ts files)
  map("n", "gD", function()
    require("vtsls").commands.goto_source_definition(0)
  end, o("Go to source definition"))

  -- Organize imports
  map("n", "<leader>co", function()
    require("vtsls").commands.organize_imports(0)
  end, o("Organize imports"))

  -- Remove unused imports
  map("n", "<leader>cu", function()
    require("vtsls").commands.remove_unused_imports(0)
  end, o("Remove unused imports"))

  -- Add missing imports
  map("n", "<leader>cm", function()
    require("vtsls").commands.add_missing_imports(0)
  end, o("Add missing imports"))

  -- Fix all auto-fixable issues
  map("n", "<leader>cf", function()
    require("vtsls").commands.fix_all(0)
  end, o("Fix all"))

  -- Rename file and update imports
  map("n", "<leader>cR", function()
    require("vtsls").commands.rename_file(0)
  end, o("Rename file (update imports)"))

  -- Select TypeScript version
  map("n", "<leader>cv", function()
    require("vtsls").commands.select_ts_version(0)
  end, o("Select TS version"))
end

return M
