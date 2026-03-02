return {
  {
    "nvim-mini/mini.pick",
    version = false,
    dependencies = { "nvim-mini/mini.extra" },
    opts = {
      options = {
        use_cache = true,
      },
      window = {
        config = function()
          local height = math.floor(vim.o.lines * 0.75)
          local width = math.floor(vim.o.columns * 0.75)
          return {
            anchor = "NW",
            height = height,
            width = width,
            row = math.floor(0.5 * (vim.o.lines - height)),
            col = math.floor(0.5 * (vim.o.columns - width)),
            border = "rounded",
          }
        end,
      },
    },
    config = function(_, opts)
      require("mini.pick").setup(opts)
      require("mini.extra").setup()
    end,
    keys = {
      {
        "<leader><leader>",
        function()
          MiniPick.builtin.files()
        end,
        desc = "Find files",
      },
      {
        "ff",
        function()
          MiniPick.builtin.files()
        end,
        desc = "Find files",
      },
      {
        "<leader>/",
        function()
          MiniPick.builtin.grep_live()
        end,
        desc = "Live grep",
      },
      {
        "<leader>?",
        function()
          MiniExtra.pickers.commands()
        end,
        desc = "Commands",
      },
      {
        "<leader>fb",
        function()
          MiniPick.builtin.buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>fr",
        function()
          MiniExtra.pickers.oldfiles()
        end,
        desc = "Recent files",
      },
      {
        "<leader>fg",
        function()
          MiniExtra.pickers.git_files()
        end,
        desc = "Git files",
      },
      {
        "<leader>fh",
        function()
          MiniPick.builtin.help()
        end,
        desc = "Help tags",
      },
      {
        "<leader>fk",
        function()
          MiniExtra.pickers.keymaps()
        end,
        desc = "Keymaps",
      },
      {
        "<leader>fd",
        function()
          MiniExtra.pickers.diagnostic({ scope = "all" })
        end,
        desc = "Diagnostics",
      },
      {
        "<leader>fs",
        function()
          MiniExtra.pickers.lsp({ scope = "document_symbol" })
        end,
        desc = "LSP symbols",
      },
      {
        "<leader>fw",
        function()
          MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>") })
        end,
        desc = "Grep word under cursor",
      },
      {
        "<leader>fc",
        function()
          MiniExtra.pickers.git_commits()
        end,
        desc = "Git commits",
      },
      {
        "<leader>e",
        function()
          MiniExtra.pickers.explorer({ cwd = vim.uv.cwd() })
        end,
        desc = "File explorer",
      },
      {
        "-",
        function()
          MiniExtra.pickers.explorer({ cwd = vim.fn.expand("%:p:h") })
        end,
        desc = "File explorer",
      },
    },
  },
}
