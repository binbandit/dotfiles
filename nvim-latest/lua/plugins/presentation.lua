return {
  {
    "LazyVim/LazyVim",
    opts = function()
      -- Create a command for presentation mode
      vim.api.nvim_create_user_command("PresentationMode", function()
        -- Increase font size (this requires external terminal support)
        -- vim.cmd("set guifont=DankMono\\ Nerd\\ Font:h18")

        -- Hide line numbers
        vim.opt.number = false
        vim.opt.relativenumber = false

        -- Hide statusline
        vim.opt.laststatus = 0

        -- Hide tabline
        vim.opt.showtabline = 0

        -- Hide command line
        vim.opt.cmdheight = 0

        -- Hide signcolumn
        vim.opt.signcolumn = "no"

        -- Increase contrast
        vim.cmd("TransparentDisable")

        -- Set a flag to indicate we're in presentation mode
        vim.g.presentation_mode = true

        -- Notify user
        vim.notify("Presentation mode enabled", vim.log.levels.INFO)
      end, {})

      -- Create a command to exit presentation mode
      vim.api.nvim_create_user_command("NormalMode", function()
        -- Reset font size
        -- vim.cmd("set guifont=DankMono\\ Nerd\\ Font:h12")

        -- Show line numbers
        vim.opt.number = true
        vim.opt.relativenumber = true

        -- Show statusline
        vim.opt.laststatus = 3

        -- Show tabline when needed
        vim.opt.showtabline = 1

        -- Show command line
        vim.opt.cmdheight = 1

        -- Show signcolumn
        vim.opt.signcolumn = "yes"

        -- Restore transparency
        vim.cmd("TransparentEnable")

        -- Clear the presentation mode flag
        vim.g.presentation_mode = false

        -- Notify user
        vim.notify("Normal mode enabled", vim.log.levels.INFO)
      end, {})

      -- Add keymaps for presentation mode
      vim.keymap.set("n", "<leader>tp", "<cmd>PresentationMode<cr>", { desc = "Toggle Presentation Mode" })
      vim.keymap.set("n", "<leader>tn", "<cmd>NormalMode<cr>", { desc = "Toggle Normal Mode" })

      -- Ensure normal mode is enabled by default
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          -- Only run if we're not already in presentation mode
          if not vim.g.presentation_mode then
            -- Run the NormalMode command to ensure all settings are applied
            vim.cmd("NormalMode")
          end
        end,
        group = vim.api.nvim_create_augroup("ensure_normal_mode", { clear = true }),
        once = true, -- Only run once on startup
      })
    end,
  },
}
