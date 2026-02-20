return {
  -- mini.ai: better text objects (around/inside)
  { "nvim-mini/mini.ai", version = "*", event = "VeryLazy", opts = {} },
  -- mini.surround: add/change/delete surroundings
  { "nvim-mini/mini.surround", version = "*", event = "VeryLazy", opts = {} },
  -- NOTE: mini.comment removed -- Neovim 0.10+ has native gc/gcc commenting
  -- NOTE: mini.basics removed -- we handle options/mappings ourselves
}
