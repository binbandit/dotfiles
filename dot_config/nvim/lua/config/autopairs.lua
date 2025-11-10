local M = {}

local registered = false
local pending_autocmd = false

local Kind = vim.lsp.protocol.CompletionItemKind

local filetype_rules = {
  ["*"] = {
    ["("] = {
      kind = { Kind.Function, Kind.Method },
      handler = "*",
    },
  },
  clojure = {
    ["("] = {
      kind = { Kind.Function, Kind.Method },
      handler = "lisp",
    },
  },
  clojurescript = {
    ["("] = {
      kind = { Kind.Function, Kind.Method },
      handler = "lisp",
    },
  },
  fennel = {
    ["("] = {
      kind = { Kind.Function, Kind.Method },
      handler = "lisp",
    },
  },
  janet = {
    ["("] = {
      kind = { Kind.Function, Kind.Method },
      handler = "lisp",
    },
  },
  tex = false,
  plaintex = false,
  context = false,
  haskell = false,
  purescript = false,
  sh = false,
  bash = false,
  nix = false,
  helm = false,
}

local function register()
  if registered then
    return true
  end

  local ok_list, list = pcall(require, "blink.cmp.completion.list")
  if not ok_list then
    return false
  end

  local ok_autopairs, autopairs = pcall(require, "nvim-autopairs")
  if not ok_autopairs then
    return false
  end

  local handlers = require("nvim-autopairs.completion.handlers")

  local function resolve_options(name)
    local opts = filetype_rules[name]
    if opts == nil then
      return nil
    end
    if opts == false then
      return false
    end
    if not opts.__resolved then
      local resolved = {}
      for char, value in pairs(opts) do
        if type(value) == "table" then
          resolved[char] = {
            kind = value.kind,
            handler = type(value.handler) == "string" and handlers[value.handler] or value.handler,
          }
        end
      end
      opts.__resolved = resolved
    end
    return opts.__resolved
  end

  local function get_completion_options(filetype)
    local opts = resolve_options(filetype)
    if opts == false then
      return nil
    end
    if opts == nil then
      opts = resolve_options("*")
    end
    return opts
  end

  list.accept_emitter:on(function(event)
    local item = event.item
    local context = event.context
    if not item or not context or not item.kind then
      return
    end

    local bufnr = context.bufnr or vim.api.nvim_get_current_buf()
    if not vim.api.nvim_buf_is_loaded(bufnr) then
      return
    end

    local completion_options = get_completion_options(vim.bo[bufnr].filetype)
    if not completion_options then
      return
    end

    local rules = {}
    for _, rule in ipairs(autopairs.get_buf_rules(bufnr)) do
      if completion_options[rule.key_map] then
        rules[#rules + 1] = rule
      end
    end

    for char, value in pairs(completion_options) do
      if value.handler and value.kind and vim.tbl_contains(value.kind, item.kind) then
        value.handler(
          char,
          item,
          bufnr,
          rules,
          item.commitCharacters or item.commit_characters or {}
        )
      end
    end
  end)

  registered = true
  return true
end

function M.setup_blink()
  if register() then
    return
  end

  if pending_autocmd then
    return
  end

  pending_autocmd = true
  vim.api.nvim_create_autocmd("InsertEnter", {
    once = true,
    callback = function()
      pending_autocmd = false
      vim.schedule(function()
        register()
      end)
    end,
  })
end

return M
