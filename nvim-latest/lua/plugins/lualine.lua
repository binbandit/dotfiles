return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local mydark = {
      normal = {
        a = { fg = '#dddddd', bg = '#000000', gui = 'bold' },
        b = { fg = '#777777', bg = '#000000' },
        c = { fg = '#777777', bg = '#000000' },
      },
      insert = {
        a = { fg = '#dddddd', bg = '#000000', gui = 'bold' },
        b = { fg = '#777777', bg = '#000000' },
        c = { fg = '#777777', bg = '#000000' },
      },
      visual = {
        a = { fg = '#dddddd', bg = '#000000', gui = 'bold' },
        b = { fg = '#777777', bg = '#000000' },
        c = { fg = '#777777', bg = '#000000' },
      },
      replace = {
        a = { fg = '#dddddd', bg = '#000000', gui = 'bold' },
        b = { fg = '#777777', bg = '#000000' },
        c = { fg = '#777777', bg = '#000000' },
      },
      command = {
        a = { fg = '#dddddd', bg = '#000000', gui = 'bold' },
        b = { fg = '#777777', bg = '#000000' },
        c = { fg = '#777777', bg = '#000000' },
      },
      inactive = {
        a = { fg = '#777777', bg = '#000000', gui = 'bold' },
        b = { fg = '#777777', bg = '#000000' },
        c = { fg = '#777777', bg = '#000000' },
      },
    }

    -- Create a custom component for supermaven status
    local supermaven_status = function()
      -- Try to get the supermaven API
      local ok, api = pcall(require, "supermaven-nvim.api")

      if not ok then
        return "AI: ?"
      end

      -- Check if supermaven is running using the API
      local is_running = api.is_running()

      if is_running then
        return "%#String#AI: ON%*"  -- Green color for ON
      else
        return "%#Error#AI: OFF%*"  -- Red color for OFF
      end
    end

    require('lualine').setup {
      options = {
        theme = mydark,
        icons_enable = true,
        globalstatus = true,
        always_divide_middle = true,
        disabled_filetypes = { -- Filetypes to disable lualine for.
          statusline = {}, -- only ignores the ft for statusline.
          winbar = {}, -- only ignores the ft for winbar.
        },
        ignore_focus = {}
      },
      sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch'},
        lualine_c = {'filename'},
        lualine_x = {supermaven_status, 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {}
      }
    }
  end
}
