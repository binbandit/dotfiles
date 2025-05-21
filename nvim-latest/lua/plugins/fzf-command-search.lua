return {
  {
    "ibhagwan/fzf-lua",
    dependencies = {
      "folke/which-key.nvim",
    },
    keys = {
      -- Add a keymap for searching commands
      {
        "<leader>fc",
        function()
          require("fzf-lua").commands()
        end,
        desc = "Find Commands",
      },
      -- Add a keymap for searching commands with a more intuitive shortcut
      {
        "<leader>?",
        function()
          require("fzf-lua").commands()
        end,
        desc = "Search Commands",
      },
      -- Add a keymap for searching help tags (documentation)
      {
        "<leader>fh",
        function()
          require("fzf-lua").help_tags()
        end,
        desc = "Find Help",
      },
      -- Add a keymap for searching keymaps
      {
        "<leader>fk",
        function()
          require("fzf-lua").keymaps()
        end,
        desc = "Find Keymaps",
      },
      -- Add more useful fzf-lua keymaps
      {
        "<leader>ff",
        function()
          require("fzf-lua").files()
        end,
        desc = "Find Files",
      },
      {
        "<leader>fg",
        function()
          require("fzf-lua").live_grep()
        end,
        desc = "Find Text (Grep)",
      },
      {
        "<leader>fb",
        function()
          require("fzf-lua").buffers()
        end,
        desc = "Find Buffers",
      },
      {
        "<leader>fr",
        function()
          require("fzf-lua").oldfiles()
        end,
        desc = "Recent Files",
      },
      {
        "<leader>fw",
        function()
          require("fzf-lua").grep_cword()
        end,
        desc = "Find Word Under Cursor",
      },
    },
    config = function(_, opts)
      -- Configure fzf-lua
      require("fzf-lua").setup({
        winopts = {
          height = 0.85,
          width = 0.80,
          row = 0.35,
          col = 0.5,
          border = "rounded",
          preview = {
            border = "border",
            wrap = "nowrap",
            hidden = "nohidden",
            vertical = "down:45%",
            horizontal = "right:60%",
            layout = "flex",
            flip_columns = 120,
            title = true,
            title_pos = "center",
          },
        },
        keymap = {
          builtin = {
            ["<C-d>"] = "preview-page-down",
            ["<C-u>"] = "preview-page-up",
            ["<C-j>"] = "next-history",
            ["<C-k>"] = "prev-history",
          },
          -- Add helpful key mappings for all pickers
          fzf = {
            ["ctrl-q"] = "select-all+accept",
            ["ctrl-a"] = "toggle-all",
          },
        },
        fzf_opts = {
          -- Options passed to the fzf command
          ["--layout"] = "reverse",
          ["--info"] = "inline",
          ["--height"] = "100%",
          ["--border"] = "none",
          ["--margin"] = "0,0",
          ["--pointer"] = "→",
          ["--marker"] = "✓",
          ["--header"] = "Ctrl-Q: Select All, Ctrl-A: Toggle All",
          ["--header-first"] = true,
          ["--color"] = "bg+:-1,fg+:blue,pointer:magenta,info:green",
        },
        previewers = {
          -- Configure previewers
          cat = {
            cmd = "cat",
            args = "--number",
          },
        },
        -- Global configuration for all pickers
        global_resume = true,      -- Enable resuming last search
        global_file_icons = true,  -- Show file icons in all pickers
        file_icon_padding = " ",   -- Add padding after file icons
        color_icons = true,        -- Colorize file icons
        commands = {
          -- Customize the commands picker
          prompt = "Commands❯ ",
          -- Format the display to show command name, key binding, and description
          fmt_item = function(cmd_data)
            local name = cmd_data.name or ""
            local cmd_str = ":" .. name

            -- Get command info
            local cmd_info = vim.api.nvim_get_commands({})
            local cmd = cmd_info[name]

            -- Add description if available
            local desc = ""
            if cmd and cmd.desc and cmd.desc ~= "" then
              desc = " - " .. cmd.desc
            end

            -- Add usage info if available
            local usage = ""
            if cmd and cmd.nargs and cmd.nargs ~= "0" then
              if cmd.nargs == "1" then
                usage = " [arg]"
              elseif cmd.nargs == "*" then
                usage = " [args...]"
              elseif cmd.nargs == "?" then
                usage = " [optional]"
              elseif cmd.nargs == "+" then
                usage = " [args...]"
              end
            end

            -- Return formatted string
            return cmd_str .. usage .. desc
          end,
          actions = {
            ["default"] = function(selected)
              -- Extract just the command name without description
              local cmd = selected[1]:match("^:([^%s]+)")
              if cmd then
                vim.cmd(cmd)
              end
            end,
          },
          -- Add helpful key binding hints
          winopts = {
            title = "Commands",
          },
        },
        helptags = {
          -- Customize the help tags picker
          prompt = "Help Tags❯ ",
          actions = {
            ["default"] = function(selected)
              vim.cmd("help " .. selected[1])
            end,
          },
        },
        keymaps = {
          -- Customize the keymaps picker
          prompt = "Keymaps❯ ",
          -- Format the display to show mode, key, and description
          fmt_item = function(keymap)
            local mode = keymap.mode or ""
            local lhs = keymap.lhs or ""
            local desc = keymap.desc or ""

            -- Format mode for display
            local mode_label = ""
            if mode == "n" then
              mode_label = "[Normal] "
            elseif mode == "i" then
              mode_label = "[Insert] "
            elseif mode == "v" then
              mode_label = "[Visual] "
            elseif mode == "x" then
              mode_label = "[Visual Block] "
            elseif mode == "s" then
              mode_label = "[Select] "
            elseif mode == "c" then
              mode_label = "[Command] "
            elseif mode == "o" then
              mode_label = "[Operator] "
            elseif mode == "t" then
              mode_label = "[Terminal] "
            else
              mode_label = "[" .. mode .. "] "
            end

            -- Return formatted string
            return mode_label .. lhs .. " → " .. desc
          end,
          winopts = {
            title = "Keymaps",
            preview = {
              hidden = "hidden",
            },
          },
        },
      })

      -- Register with which-key
      local wk = require("which-key")
      wk.register({
        ["<leader>f"] = {
          name = "Find/Search",
          f = { function() require("fzf-lua").files() end, "Find Files" },
          g = { function() require("fzf-lua").live_grep() end, "Find Text (Grep)" },
          b = { function() require("fzf-lua").buffers() end, "Find Buffers" },
          c = { function() require("fzf-lua").commands() end, "Find Commands" },
          h = { function() require("fzf-lua").help_tags() end, "Find Help" },
          k = { function() require("fzf-lua").keymaps() end, "Find Keymaps" },
          r = { function() require("fzf-lua").oldfiles() end, "Recent Files" },
          w = { function() require("fzf-lua").grep_cword() end, "Find Word Under Cursor" },
        },
        ["<leader>?"] = { function() require("fzf-lua").commands() end, "Search Commands" },
      })
    end,
  },
}
