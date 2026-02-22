local M = {}

local leader_groups = {
  -- Groups
  { "<leader>b",        group = "Buffers" },
  { "<leader>c",        group = "Code" },
  { "<leader>d",        group = "Debug" },
  { "<leader>f",        group = "Find" },
  { "<leader>g",        group = "Git & GitHub" },
  { "<leader>h",        group = "Harpoon / Hunks" },
  { "<leader>l",        group = "LSP" },
  { "<leader>q",        group = "Quit" },
  { "<leader>r",        group = "Rust / Run" },
  { "<leader>s",        group = "Splits" },
  { "<leader>t",        group = "Toggles" },
  { "<leader>T",        group = "Tests" },
  { "<leader>u",        group = "UI" },
  { "<leader>x",        group = "Trouble" },
  { "<leader>9",        group = "99 AI" },

  -- Top-level
  { "<leader>w",        desc = "Write buffer" },
  { "<leader>e",        desc = "Explorer" },
  { "<leader>z",        desc = "Zen mode" },
  { "<leader>/",        desc = "Live Grep" },
  { "<leader>?",        desc = "Commands" },
  { "<leader>|",        desc = "Vertical Split" },
  { "<leader>`",        desc = "Alternate Buffer" },
  { "<leader><leader>", desc = "Find files" },
  { "<leader>qq",       desc = "Quit" },
  { "<leader>99",       desc = "99 search" },
  { "<leader>9s",       desc = "99 search" },
  { "<leader>9v",       desc = "99 visual edit" },
  { "<leader>9x",       desc = "99 stop requests" },
  { "<leader>9i",       desc = "99 session info" },
  { "<leader>9l",       desc = "99 view logs" },
  { "<leader>9h",       desc = "99 health check" },
  { "<leader>9m",       desc = "99 select model" },

  -- Find
  { "<leader>fb",       desc = "Buffers" },
  { "<leader>fr",       desc = "Recent files" },
  { "<leader>fg",       desc = "Git files" },
  { "<leader>fh",       desc = "Help tags" },
  { "<leader>fk",       desc = "Keymaps" },
  { "<leader>fd",       desc = "Diagnostics" },
  { "<leader>fs",       desc = "LSP symbols" },
  { "<leader>fw",       desc = "Grep word" },
  { "<leader>fc",       desc = "Git commits" },
  { "<leader>fn",       desc = "Notifications" },
  { "<leader>ft",       desc = "Todo comments" },

  -- Buffers
  { "<leader>bd",       desc = "Delete buffer" },

  -- Code (language-specific, shared prefix)
  { "<leader>co",       desc = "Organize imports" },
  { "<leader>cu",       desc = "Remove unused imports / Update crate" },
  { "<leader>cm",       desc = "Add missing imports" },
  { "<leader>cf",       desc = "Fix all / Crate features" },
  { "<leader>cR",       desc = "Rename file (update imports)" },
  { "<leader>cv",       desc = "Select TS version / Crate versions" },
  { "<leader>cd",       desc = "Crate documentation" },
  { "<leader>cU",       desc = "Update all crates" },
  { "<leader>cH",       desc = "Crate homepage" },

  -- Debug
  { "<leader>db",       desc = "Toggle breakpoint" },
  { "<leader>dB",       desc = "Conditional breakpoint" },
  { "<leader>dc",       desc = "Continue" },
  { "<leader>dC",       desc = "Run to cursor" },
  { "<leader>di",       desc = "Step into" },
  { "<leader>do",       desc = "Step over" },
  { "<leader>dO",       desc = "Step out" },
  { "<leader>dr",       desc = "Toggle REPL" },
  { "<leader>dl",       desc = "Run last" },
  { "<leader>dt",       desc = "Terminate" },
  { "<leader>du",       desc = "Toggle DAP UI" },
  { "<leader>de",       desc = "Eval under cursor" },

  -- Git
  { "<leader>gg",       desc = "Lazygit" },
  { "<leader>gb",       desc = "Git blame line" },

  -- Harpoon / Git hunks
  { "<leader>ha",       desc = "Harpoon add file" },
  { "<leader>he",       desc = "Harpoon toggle menu" },
  { "<leader>h1",       desc = "Harpoon goto 1" },
  { "<leader>h2",       desc = "Harpoon goto 2" },
  { "<leader>h3",       desc = "Harpoon goto 3" },
  { "<leader>h4",       desc = "Harpoon goto 4" },
  { "<leader>hp",       desc = "Harpoon previous" },
  { "<leader>hP",       desc = "Preview git hunk" },
  { "<leader>hn",       desc = "Harpoon next" },
  { "<leader>hs",       desc = "Stage git hunk" },
  { "<leader>hr",       desc = "Reset git hunk" },
  { "<leader>hS",       desc = "Stage buffer" },
  { "<leader>hu",       desc = "Undo stage hunk" },
  { "<leader>hb",       desc = "Blame line" },
  { "<leader>hd",       desc = "Diff this" },

  -- Rust (only active in Rust files via ftplugin)
  { "<leader>rr",       desc = "Runnables" },
  { "<leader>rl",       desc = "Rerun last" },
  { "<leader>rt",       desc = "Testables" },
  { "<leader>rd",       desc = "Debuggables" },
  { "<leader>re",       desc = "Expand macro" },
  { "<leader>rx",       desc = "Explain error" },
  { "<leader>rD",       desc = "Render diagnostic" },
  { "<leader>rc",       desc = "Open Cargo.toml" },
  { "<leader>ro",       desc = "Open docs.rs" },
  { "<leader>rp",       desc = "Parent module" },
  { "<leader>rT",       desc = "Related tests" },
  { "<leader>rR",       desc = "Rebuild proc macros" },
  { "<leader>rf",       desc = "Fly check (clippy)" },
  { "<leader>rg",       desc = "Crate graph" },
  { "<leader>rs",       desc = "Structural search replace" },

  -- Tests
  { "<leader>Tr",       desc = "Run nearest test" },
  { "<leader>Tf",       desc = "Run file tests" },
  { "<leader>Ts",       desc = "Toggle test summary" },
  { "<leader>To",       desc = "Test output" },
  { "<leader>Tp",       desc = "Toggle output panel" },
  { "<leader>Td",       desc = "Debug nearest test" },
  { "<leader>Tl",       desc = "Rerun last test" },
  { "<leader>TS",       desc = "Stop test" },

  -- Toggles
  { "<leader>ti",       desc = "Toggle inlay hints" },
  { "<leader>tl",       desc = "Toggle diagnostic virtual lines" },
  { "<leader>td",       desc = "Toggle dim" },

  -- UI
  { "<leader>uu",       desc = "Toggle Undotree" },

  -- Splits
  { "<leader>sv",       desc = "Split right" },
  { "<leader>sh",       desc = "Split below" },

  -- Non-leader
  { "gd",               desc = "Goto Definition" },
  { "gD",               desc = "Goto Source Definition" },
  { "grn",              desc = "Rename (native)" },
  { "grr",              desc = "References (native)" },
  { "gri",              desc = "Implementation (native)" },
  { "gra",              desc = "Code Action (native)" },
  { "gO",               desc = "Document Symbols (native)" },
  { "g<C-]>",           desc = "Tag jump" },
  { "gl",               desc = "Line Diagnostics" },
  { "K",                desc = "Hover" },
  { "ff",               desc = "Find files" },
  { "]]",               desc = "Next LSP reference" },
  { "[[",               desc = "Prev LSP reference" },
  { "[d",               desc = "Previous diagnostic" },
  { "]d",               desc = "Next diagnostic" },
  { "[e",               desc = "Previous error" },
  { "]e",               desc = "Next error" },
  { "]h",               desc = "Next git hunk" },
  { "[h",               desc = "Previous git hunk" },
  { "]t",               desc = "Next todo comment" },
  { "[t",               desc = "Previous todo comment" },
  { "]T",               desc = "Next failed test" },
  { "[T",               desc = "Prev failed test" },
}

function M.setup()
  local wk = require("which-key")
  wk.setup({
    notify = false,
    plugins = {
      marks = false,
      registers = false,
    },
    win = {
      border = "rounded",
    },
  })
  wk.add(leader_groups)
end

return M
