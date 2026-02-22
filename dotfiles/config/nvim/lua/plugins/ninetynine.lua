return {
  "ThePrimeagen/99",
  event = "VeryLazy",
  dependencies = {
    "hrsh7th/nvim-cmp",
  },
  config = function()
    local _99 = require("99")

    local cwd = vim.uv.cwd() or ""
    local basename = vim.fs.basename(cwd)

    local function read_opencode_models()
      if vim.fn.executable("opencode") ~= 1 then
        return {}
      end
      local lines = vim.fn.systemlist("opencode models")
      if vim.v.shell_error ~= 0 then
        return {}
      end
      local models = {}
      for _, line in ipairs(lines) do
        if line ~= "" then
          table.insert(models, line)
        end
      end
      return models
    end

    local function contains(tbl, value)
      for _, item in ipairs(tbl) do
        if item == value then
          return true
        end
      end
      return false
    end

    local function pick_model(models)
      local env_model = vim.env.NVIM_99_MODEL or vim.env.OPENCODE_MODEL or vim.env.LLMLITE_MODEL
      if env_model and contains(models, env_model) then
        return env_model
      end

      for _, model in ipairs(models) do
        if model:find("llmlite", 1, true) then
          return model
        end
      end

      local preferred = {
        "anthropic/claude-sonnet-4-5",
        "openai/gpt-5.3-codex",
        "openai/gpt-5-codex",
      }
      for _, model in ipairs(preferred) do
        if contains(models, model) then
          return model
        end
      end

      return models[1]
    end

    local opencode_models = read_opencode_models()
    local selected_model = pick_model(opencode_models)

    _99.setup({
      model = selected_model,
      logger = {
        level = _99.WARN,
        path = "/tmp/" .. (basename ~= "" and basename or "nvim") .. ".99.debug",
        print_on_error = true,
      },
      tmp_dir = "./tmp",
      completion = {
        source = "cmp",
        custom_rules = {},
        files = {
          exclude = { ".git", "node_modules", "dist", "build", ".next", "coverage" },
        },
      },
      md_files = {
        "AGENT.md",
      },
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "99-prompt",
      callback = function(event)
        local buf = event.buf
        vim.keymap.set("n", "<CR>", "<cmd>write<CR>", { buffer = buf, silent = true, desc = "99 submit prompt" })
        vim.keymap.set("n", "<C-s>", "<cmd>write<CR>", { buffer = buf, silent = true, desc = "99 submit prompt" })
        vim.keymap.set("n", "<Esc>", "<cmd>q<CR>", { buffer = buf, silent = true, desc = "99 cancel prompt" })
      end,
    })

    vim.keymap.set("n", "<leader>99", function()
      _99.search()
    end, { desc = "99 search" })

    vim.keymap.set("n", "<leader>9s", function()
      _99.search()
    end, { desc = "99 search" })

    vim.keymap.set("v", "<leader>9v", function()
      _99.visual()
    end, { desc = "99 visual edit" })

    vim.keymap.set("n", "<leader>9x", function()
      _99.stop_all_requests()
    end, { desc = "99 stop requests" })

    vim.keymap.set("n", "<leader>9i", function()
      _99.info()
    end, { desc = "99 session info" })

    vim.keymap.set("n", "<leader>9l", function()
      _99.view_logs()
    end, { desc = "99 view logs" })

    vim.keymap.set("n", "<leader>9h", function()
      local provider = _99.get_provider()._get_provider_name()
      local current_model = _99.get_model()
      local models = read_opencode_models()
      local has_model = contains(models, current_model)

      local lines = {
        "99 Health",
        "provider: " .. provider,
        "model: " .. current_model,
        "opencode CLI: " .. (vim.fn.executable("opencode") == 1 and "OK" or "MISSING"),
        "claude CLI: " .. (vim.fn.executable("claude") == 1 and "OK" or "MISSING"),
      }

      if #models > 0 then
        table.insert(lines, "opencode models: " .. #models)
        table.insert(lines, "active model available: " .. (has_model and "yes" or "no"))
      else
        table.insert(lines, "opencode models: unavailable")
      end

      if not has_model and #models > 0 then
        table.insert(lines, "hint: set NVIM_99_MODEL to one of `opencode models`")
      end

      vim.notify(table.concat(lines, "\n"), has_model and vim.log.levels.INFO or vim.log.levels.WARN)
    end, { desc = "99 health check" })

    vim.keymap.set("n", "<leader>9m", function()
      local models = read_opencode_models()
      if #models == 0 then
        vim.notify("No models found from `opencode models`", vim.log.levels.WARN)
        return
      end

      vim.ui.select(models, { prompt = "99: Select model" }, function(choice)
        if not choice or choice == "" then
          return
        end
        _99.set_model(choice)
        vim.notify("99 model set to: " .. choice, vim.log.levels.INFO)
      end)
    end, { desc = "99 select model" })
  end,
}
