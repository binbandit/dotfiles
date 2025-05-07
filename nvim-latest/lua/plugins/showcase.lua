return {
  -- Add a showcase command for presentations
  {
    "LazyVim/LazyVim",
    opts = function()
      -- Create a command to toggle font size for presentations
      vim.api.nvim_create_user_command("Showcase", function(opts)
        if not vim.g.neovide then
          vim.notify("Showcase command only works in GUI mode (like Neovide)", vim.log.levels.WARN)
          return
        end

        local size = opts.args ~= "" and tonumber(opts.args) or 24
        
        if vim.g.showcase_mode then
          -- Return to normal size
          vim.o.guifont = vim.g.font_name .. ":h" .. vim.g.default_font_size
          vim.g.showcase_mode = false
          vim.notify("Showcase mode disabled", vim.log.levels.INFO)
        else
          -- Set to presentation size
          vim.o.guifont = vim.g.font_name .. ":h" .. size
          vim.g.showcase_mode = true
          vim.notify("Showcase mode enabled (font size: " .. size .. ")", vim.log.levels.INFO)
        end
      end, { nargs = "?", desc = "Toggle showcase mode for presentations" })

      -- Add keymaps for showcase mode
      vim.keymap.set("n", "<leader>ps", "<cmd>Showcase<cr>", { desc = "Toggle Showcase Mode" })
      vim.keymap.set("n", "<leader>pS", function()
        vim.ui.input({ prompt = "Enter font size: " }, function(size)
          if size and tonumber(size) then
            vim.cmd("Showcase " .. size)
          end
        end)
      end, { desc = "Showcase with custom size" })
    end,
  },
}
