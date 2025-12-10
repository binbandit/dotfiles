return {
  {
    "A7Lavinraj/fyler.nvim",
    dependencies = { "nvim-mini/mini.icons" },
    branch = "stable", -- Use stable branch for production
    lazy = false, -- Necessary for `default_explorer` to work properly
    keys = {
      { "-", "<cmd>Fyler<cr>", desc = "Open Fyler" },
    },
    opts = {
      views = {
        finder = {
		close_on_select = true,
		confirm_simple = false,
		delete_to_trash = true,
		default_explorer = true,
		follow_current_file = true,
        },
      },
    },
  },
}
