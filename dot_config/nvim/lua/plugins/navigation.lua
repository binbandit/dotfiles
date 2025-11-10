---@type LazySpec
return {
  {
    "ibhagwan/fzf-lua",
    opts = {},
    config = function(_, opts)
      local fzf = require("fzf-lua")
      fzf.setup(opts)
      fzf.register_ui_select()
    end,
  },
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      default_file_explorer = true,
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      cleanup_delay_ms = 100,
      use_default_keymaps = true,
      view_options = {
        show_hidden = false,
        is_always_hidden = function(name)
          return vim.startswith(name, ".git")
        end,
      },
      win_options = {
        signcolumn = "auto",
      },
      keymaps = {},
    },
    dependencies = {
      { "echasnovski/mini.icons", opts = {} },
    },
    lazy = false,
    keys = {
      { "<leader>o", function() require("oil").open() end, desc = "Open oil" },
      { "<leader>e", function() require("oil").open() end, desc = "Open oil" },
    },
  },
  {
    "dmtrKovalenko/fff.nvim",
    build = function()
      require("fff.download").download_or_build_binary()
    end,
    opts = {},
    lazy = false,
    config = function(_, opts)
      require("fff").setup(opts)
    end,
    keys = {
      { "ff", function() require("fff").find_files() end, desc = "Find files" },
      { "<leader><leader>", function() require("fff").find_files() end, desc = "Find files" },
    },
  },
  {
    "mluders/comfy-line-numbers.nvim",
    config = function()
      require("comfy-line-numbers").setup({
        labels = {
          '1', '2', '3', '4', '5', '11', '12', '13', '14', '15', '21', '22', '23',
          '24', '25', '31', '32', '33', '34', '35', '41', '42', '43', '44', '45',
          '51', '52', '53', '54', '55', '111', '112', '113', '114', '115', '121',
          '122', '123', '124', '125', '131', '132', '133', '134', '135', '141',
          '142', '143', '144', '145', '151', '152', '153', '154', '155', '211',
          '212', '213', '214', '215', '221', '222', '223', '224', '225', '231',
          '232', '233', '234', '235', '241', '242', '243', '244', '245', '251',
          '252', '253', '254', '255',
        },
        up_key = 'k',
        down_key = 'j',
        hidden_file_types = { 'undotree' },
        hidden_buffer_types = { 'terminal', 'nofile' }
      })
      
      -- After the plugin sets up the j/k mappings, create additional mappings for arrow keys
      vim.defer_fn(function()
        local labels = {
          '1', '2', '3', '4', '5', '11', '12', '13', '14', '15', '21', '22', '23',
          '24', '25', '31', '32', '33', '34', '35', '41', '42', '43', '44', '45',
          '51', '52', '53', '54', '55', '111', '112', '113', '114', '115', '121',
          '122', '123', '124', '125', '131', '132', '133', '134', '135', '141',
          '142', '143', '144', '145', '151', '152', '153', '154', '155', '211',
          '212', '213', '214', '215', '221', '222', '223', '224', '225', '231',
          '232', '233', '234', '235', '241', '242', '243', '244', '245', '251',
          '252', '253', '254', '255',
        }
        
        -- Create the same mappings but with arrow keys
        for index, label in ipairs(labels) do
          -- Map label + Up arrow to the same as label + k
          vim.keymap.set({ 'n', 'v', 'o' }, label .. '<Up>', index .. 'k', { noremap = true })
          -- Map label + Down arrow to the same as label + j
          vim.keymap.set({ 'n', 'v', 'o' }, label .. '<Down>', index .. 'j', { noremap = true })
        end
      end, 50)
    end,
    lazy = false,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      
      -- REQUIRED: Setup harpoon
      harpoon:setup()
      
      -- Global key mappings for harpoon (intuitive mappings)
      vim.keymap.set("n", "<leader>ha", function() harpoon:list():append() end, { desc = "Harpoon add file" })
      vim.keymap.set("n", "<leader>he", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon toggle menu" })
      
      -- Navigation to harpoon marks (using leader key for which-key compatibility)
      vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end, { desc = "Harpoon goto 1" })
      vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end, { desc = "Harpoon goto 2" })
      vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end, { desc = "Harpoon goto 3" })
      vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end, { desc = "Harpoon goto 4" })
      
      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end, { desc = "Harpoon previous" })
      vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end, { desc = "Harpoon next" })
      
    end,
    keys = {
      "<leader>ha",
      "<leader>he",
      "<leader>h1",
      "<leader>h2",
      "<leader>h3",
      "<leader>h4",
      "<leader>hp",
      "<leader>hn",
    },
  },
  {
    "j-morano/buffer_manager.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    config = function(_, opts)
      require("buffer_manager").setup(opts)
    end,
    keys = {
      { "<leader>bb", function() require("buffer_manager.ui").toggle_quick_menu() end, desc = "Buffer manager" },
    },
  },
}
