local M = {}
local initialized = false

local function get_upvalue(fn, name)
  local index = 1
  while true do
    local upname, value = debug.getupvalue(fn, index)
    if not upname then
      return nil
    end
    if upname == name then
      return value
    end
    index = index + 1
  end
end

function M.setup()
  if initialized then
    return
  end

  local ok, inlay_hint = pcall(function()
    return require("vim.lsp.inlay_hint")
  end)
  if not ok then
    return
  end

  local namespace = get_upvalue(inlay_hint.enable, "namespace")
  local bufstates = get_upvalue(inlay_hint.enable, "bufstates")

  if not namespace or not bufstates then
    return
  end

  local util = require("vim.lsp.util")
  local api = vim.api
  local last_error
  local last_error_time = 0

  local function clamp_col(col, max)
    if not col or col < 0 then
      return 0
    end
    if max >= 0 and col > max then
      return max
    end
    return col
  end

  local function warn_once(err)
    if not err then
      return
    end
    if err == last_error and (vim.loop.now() - last_error_time) < 1000 then
      return
    end
    last_error = err
    last_error_time = vim.loop.now()
    vim.schedule(function()
      vim.notify_once(
        ("Inlay hint render failed: %s"):format(err),
        vim.log.levels.DEBUG,
        { title = "LSP Inlay Hints" }
      )
    end)
  end

  local function safe_on_win(_, _, bufnr, topline, botline)
    local bufstate = rawget(bufstates, bufnr)
    if not bufstate then
      return
    end

    if bufstate.version ~= util.buf_versions[bufnr] then
      return
    end

    if not bufstate.client_hints then
      return
    end

    local client_hints = bufstate.client_hints

    for lnum = topline, botline do
      if bufstate.applied[lnum] ~= bufstate.version then
        api.nvim_buf_clear_namespace(bufnr, namespace, lnum, lnum + 1)

        local hint_virtual_texts = {}
        for _, lnum_hints in pairs(client_hints) do
          local hints = lnum_hints[lnum]
          if hints then
            for _, hint in pairs(hints) do
              local text = ""
              local label = hint.label
              if type(label) == "string" then
                text = label
              elseif type(label) == "table" then
                for _, part in ipairs(label) do
                  text = text .. (part.value or "")
                end
              end

              local vt = hint_virtual_texts[hint.position.character] or {}
              if hint.paddingLeft then
                vt[#vt + 1] = { " " }
              end
              vt[#vt + 1] = { text, "LspInlayHint" }
              if hint.paddingRight then
                vt[#vt + 1] = { " " }
              end
              hint_virtual_texts[hint.position.character] = vt
            end
          end
        end

        local line = api.nvim_buf_get_lines(bufnr, lnum, lnum + 1, false)[1] or ""
        local max_col = #line

        for pos, vt in pairs(hint_virtual_texts) do
          local clamped = clamp_col(pos, max_col)
          local ok_extmark, err = pcall(api.nvim_buf_set_extmark, bufnr, namespace, lnum, clamped, {
            virt_text_pos = "inline",
            ephemeral = false,
            virt_text = vt,
          })
          if not ok_extmark then
            warn_once(err)
          end
        end

        bufstate.applied[lnum] = bufstate.version
      end
    end
  end

  api.nvim_set_decoration_provider(namespace, { on_win = safe_on_win })
  initialized = true
end

return M
