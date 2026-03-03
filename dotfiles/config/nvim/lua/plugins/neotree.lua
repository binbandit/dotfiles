return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
          never_show = { ".git" },
        },
      },
    },
    keys = {
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({
            source = "filesystem",
            toggle = true,
            dir = vim.fn.getcwd(),
          })
        end,
        desc = "File explorer",
      },
      {
        "-",
        function()
          local file = vim.fn.expand("%:p")
          if file == "" then
            file = vim.fn.getcwd()
          end

          local dir = file
          if vim.fn.filereadable(file) == 1 then
            dir = vim.fn.fnamemodify(file, ":h")
          end

          require("neo-tree.command").execute({
            source = "filesystem",
            toggle = true,
            dir = dir,
            reveal_file = file,
            reveal_force_cwd = true,
          })
        end,
        desc = "File explorer",
      },
    },
  },
}
