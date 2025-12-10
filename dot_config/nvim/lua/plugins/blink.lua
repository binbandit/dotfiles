return {
  "saghen/blink.cmp",
  version = "v0.*",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  opts = {
    keymap = {
      preset = "super-tab",
    },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      providers = {
        snippets = {
          should_show_items = function(ctx)
            local start_col = ctx.bounds and ctx.bounds.start_col or 1
            if start_col <= 1 then return true end

            local line = ctx.line or ""
            local previous_char = line:sub(start_col - 1, start_col - 1)
            return previous_char ~= "."
          end,
        },
      },
    },
    completion = {
      accept = {
        auto_brackets = { enabled = true },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
      list = {
        selection = { preselect = true, auto_insert = false },
      },
    },
    signature = {
      enabled = true,
    },
  },
}
