-- Module for LazyVim extras functionality
local M = {}

-- Function to search LazyVim extras
function M.search_extras()
  -- Check if fzf-lua is available
  local ok, fzf_lua = pcall(require, "fzf-lua")
  if not ok then
    vim.notify("fzf-lua is not available", vim.log.levels.ERROR)
    return
  end
  
  -- Get the list of all available LazyVim extras
  local extras = {}
  local lazy_extras_dir = vim.fn.stdpath("data") .. "/lazy/LazyVim/lua/lazyvim/plugins/extras"
  
  -- Function to scan directories recursively
  local function scan_dir(dir, prefix)
    prefix = prefix or ""
    local handle = vim.loop.fs_scandir(dir)
    if not handle then return end
    
    while true do
      local name, type = vim.loop.fs_scandir_next(handle)
      if not name then break end
      
      local path = dir .. "/" .. name
      local extra_name = prefix .. (prefix ~= "" and "." or "") .. name:gsub("%.lua$", "")
      
      if type == "directory" then
        scan_dir(path, extra_name)
      elseif name:match("%.lua$") and name ~= "init.lua" then
        local extra_id = "lazyvim.plugins.extras." .. extra_name
        
        -- Read the file to get description
        local lines = {}
        local file = io.open(path, "r")
        if file then
          for line in file:lines() do
            table.insert(lines, line)
            -- Only read the first 20 lines to find a description
            if #lines >= 20 then break end
          end
          file:close()
        end
        
        -- Try to extract a description from the file content
        local desc = ""
        for _, line in ipairs(lines) do
          -- Look for comments that might describe the extra
          local comment = line:match("^%s*%-%-%s*(.+)")
          if comment and not comment:match("^@") and #comment > 10 then
            desc = comment
            break
          end
        end
        
        -- Add to extras list
        table.insert(extras, {
          id = extra_id,
          name = extra_name,
          desc = desc,
        })
      end
    end
  end
  
  -- Scan the extras directory
  scan_dir(lazy_extras_dir)
  
  -- Sort extras by name
  table.sort(extras, function(a, b) return a.name < b.name end)
  
  -- Format extras for display
  local formatted_extras = {}
  for _, extra in ipairs(extras) do
    local display = extra.id
    if extra.desc and extra.desc ~= "" then
      display = display .. " - " .. extra.desc
    end
    table.insert(formatted_extras, display)
  end
  
  -- Show extras in fzf-lua
  fzf_lua.fzf_exec(formatted_extras, {
    prompt = "LazyVim Extras❯ ",
    actions = {
      ["default"] = function(selected)
        -- Extract the extra ID
        local extra_id = selected[1]:match("^([^%s]+)")
        
        -- Check if it's already enabled
        local lazyvim_json = vim.fn.stdpath("config") .. "/lazyvim.json"
        local file = io.open(lazyvim_json, "r")
        if not file then
          vim.notify("Could not open lazyvim.json", vim.log.levels.ERROR)
          return
        end
        
        local content = file:read("*all")
        file:close()
        
        local json_ok, json_data = pcall(vim.fn.json_decode, content)
        if not json_ok or not json_data or not json_data.extras then
          vim.notify("Could not parse lazyvim.json", vim.log.levels.ERROR)
          return
        end
        
        -- Check if the extra is already enabled
        local is_enabled = false
        for _, enabled_extra in ipairs(json_data.extras) do
          if enabled_extra == extra_id then
            is_enabled = true
            break
          end
        end
        
        -- Ask the user what to do
        if is_enabled then
          vim.ui.select(
            { "Disable", "Cancel" },
            { prompt = extra_id .. " is already enabled. What would you like to do?" },
            function(choice)
              if choice == "Disable" then
                -- Remove the extra from the list
                local new_extras = {}
                for _, enabled_extra in ipairs(json_data.extras) do
                  if enabled_extra ~= extra_id then
                    table.insert(new_extras, enabled_extra)
                  end
                end
                json_data.extras = new_extras
                
                -- Write the updated JSON
                local new_content = vim.fn.json_encode(json_data)
                file = io.open(lazyvim_json, "w")
                if file then
                  file:write(new_content)
                  file:close()
                  vim.notify("Disabled " .. extra_id .. ". Restart Neovim to apply changes.", vim.log.levels.INFO)
                else
                  vim.notify("Could not write to lazyvim.json", vim.log.levels.ERROR)
                end
              end
            end
          )
        else
          vim.ui.select(
            { "Enable", "Cancel" },
            { prompt = "Enable " .. extra_id .. "?" },
            function(choice)
              if choice == "Enable" then
                -- Add the extra to the list
                table.insert(json_data.extras, extra_id)
                
                -- Write the updated JSON
                local new_content = vim.fn.json_encode(json_data)
                file = io.open(lazyvim_json, "w")
                if file then
                  file:write(new_content)
                  file:close()
                  vim.notify("Enabled " .. extra_id .. ". Restart Neovim to apply changes.", vim.log.levels.INFO)
                else
                  vim.notify("Could not write to lazyvim.json", vim.log.levels.ERROR)
                end
              end
            end
          )
        end
      end
    },
    winopts = {
      height = 0.8,
      width = 0.9,
      preview = {
        hidden = "hidden",
      },
    },
  })
end

return M
