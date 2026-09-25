-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local dap = require("dap")
dap.adapters.gdb = {
  type = "executable",
  command = "gdb",
  args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
}
dap.adapters["rust-gdb"] = {
  type = "executable",
  command = "rust-gdb",
  args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
}

dap.configurations.c = {
  {
    name = "Launch",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    args = {}, -- provide arguments if needed
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
  },
  {
    name = "Select and attach to process",
    type = "gdb",
    request = "attach",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    pid = function()
      local name = vim.fn.input("Executable name(filter): ")
      return require("dap.utils").pick_process({ filter = name })
    end,
    cwd = "${workspaceFolder}",
  },
  {
    name = "Attach to gdbserver :1234",
    type = "gdb",
    request = "attach",
    target = "localhost:1234",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
  },
}
dap.configurations.cpp = dap.configurations.c
dap.configurations.rust = {
  {
    name = "Launch",
    type = "rust-gdb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    args = {}, -- provide arguments if needed
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
  },
  {
    name = "Select and attach to process",
    type = "rust-gdb",
    request = "attach",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    pid = function()
      local name = vim.fn.input("Executable name(filter): ")
      return require("dap.utils").pick_process({ filter = name })
    end,
    cwd = "${workspaceFolder}",
  },
  {
    name = "Attach to gdbserver :1234",
    type = "rust-gdb",
    request = "attach",
    target = "localhost:1234",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
  },
}

require("session-keys").sessions.dap = {
  n = { -- mode 'n'
    {
      lhs = "<F5>",
      rhs = function()
        require("dap").continue()
      end,
      opts = { desc = "Run, continue" },
    },
    {
      lhs = "<F17>",
      rhs = function()
        require("dap").run_to_cursor()
      end,
      opts = { desc = "Run to cursor" },
    },
    {
      lhs = "<F9>",
      rhs = function()
        require("dap").toggle_breakpoint()
      end,
      opts = { desc = "Toggle breakpoint" },
    },
    {
      lhs = "<F10>",
      rhs = function()
        require("dap").step_over()
      end,
      opts = { desc = "Step over" },
    },
    {
      lhs = "<F11>",
      rhs = function()
        require("dap").step_into()
      end,
      opts = { desc = "Step into" },
    },
    {
      lhs = "<F23>",
      rhs = function()
        require("dap").step_out()
      end,
      opts = { desc = "Step out" },
    },

    {
      lhs = "<F8>",
      rhs = function()
        require("dap").terminate()
      end,
      opts = { desc = "Terminate" },
    },
    {
      lhs = "<F20>",
      rhs = function()
        require("dap").disconnect({ terminateDebuggee = false })
      end,
      opts = { desc = "Disconnect" },
    },
    {
      lhs = "<F29>",
      rhs = function()
        require("dap").run_last()
      end,
      opts = { desc = "Run last" },
    },

    {
      lhs = "<F6>",
      rhs = function()
        require("dap").down()
      end,
      opts = { desc = "Go down in current stacktrace without stepping" },
    },
    {
      lhs = "<F18>",
      rhs = function()
        require("dap").up()
      end,
      opts = { desc = "Go up in current stacktrace without stepping" },
    },

    {
      lhs = "<F7>",
      rhs = function()
        require("dap").pause()
      end,
      opts = { desc = "Pause thread" },
    },

    {
      lhs = "<F41>",
      rhs = function()
        require("dap").reverse_continue()
      end,
      opts = { desc = "Reverse continue" },
    },
    {
      lhs = "<F22>",
      rhs = function()
        require("dap").step_back()
      end,
      opts = { desc = "Step back" },
    },
  },
}

vim.keymap.set("n", "<leader>dk", function()
  require("session-keys"):toggle("dap")
end, { desc = "Toggle DAP session keys" })

vim.api.nvim_create_user_command("LspRestart", function(command)
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  local restart = {}

  for _, client in ipairs(clients) do
    if command.args == "" or client.name == command.args then
      restart[#restart + 1] = client.config
      client:stop(true)
    end
  end

  if #restart == 0 then
    vim.notify("No matching LSP client attached to this buffer", vim.log.levels.WARN)
    return
  end

  vim.defer_fn(function()
    for _, config in ipairs(restart) do
      vim.lsp.start(config, { bufnr = bufnr })
    end
  end, 100)
end, {
  nargs = "?",
  complete = function()
    local names = {}
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
      names[#names + 1] = client.name
    end
    return names
  end,
  desc = "Restart LSP clients attached to the current buffer",
})
