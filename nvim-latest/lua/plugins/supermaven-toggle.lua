return {
  {
    "supermaven-inc/supermaven-nvim",
    dependencies = {
      "folke/which-key.nvim",
    },
    config = function(_, opts)
      -- Add direct keymap to toggle supermaven (without which-key)
      vim.keymap.set("n", "<leader>ai", function()
        require("user.supermaven").toggle()
      end, { desc = "Toggle AI Autocomplete" })
    end,
  },
}
