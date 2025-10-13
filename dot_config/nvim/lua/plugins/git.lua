---@type LazySpec
return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "▎" },
        topdelete = { text = "▔" },
        changedelete = { text = "▎" },
      },
      attach_to_untracked = true,
      current_line_blame = false,
    },
    config = function(_, opts)
      opts.on_attach = function(bufnr)
        local gs = require("gitsigns")
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map("n", "]h", gs.next_hunk, "Next git hunk")
        map("n", "[h", gs.prev_hunk, "Previous git hunk")
        map({ "n", "v" }, "<leader>gs", gs.stage_hunk, "Stage git hunk")
        map({ "n", "v" }, "<leader>gr", gs.reset_hunk, "Reset git hunk")
        map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")
        map("n", "<leader>gP", gs.preview_hunk_inline, "Preview git hunk")
        map("n", "<leader>gB", function()
          gs.blame_line({ full = true })
        end, "Git blame (full)")
      end

      require("gitsigns").setup(opts)
    end,
  },
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "folke/snacks.nvim",
    },
    opts = {
      default_remote = { "origin", "upstream" },
      picker = "snacks",
      mappings_disable_default = false,
    },
    keys = {
      { "<leader>go", "<cmd>Octo actions<CR>", desc = "Octo actions" },
      { "<leader>gi", "<cmd>Octo issue list<CR>", desc = "List issues" },
      { "<leader>gp", "<cmd>Octo pr list<CR>", desc = "List pull requests" },
      { "<leader>gN", "<cmd>Octo issue create<CR>", desc = "Create issue" },
      { "<leader>gn", "<cmd>Octo notification list<CR>", desc = "Notifications" },
    },
    config = function(_, opts)
      require("octo").setup(opts)
    end,
  },
}
