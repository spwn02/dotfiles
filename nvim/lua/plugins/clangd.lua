local clang_fork_root = vim.env.CLANG_FORK_ROOT or vim.fn.expand("~/.local/opt/clang-cxx26")

local function first_executable(candidates)
  for _, candidate in ipairs(candidates) do
    if candidate ~= "" and vim.fn.executable(candidate) == 1 then
      return candidate
    end
  end
end

local clangd = first_executable({
  clang_fork_root .. "/bin/clangd",
  vim.fn.exepath("clangd"),
})
local clangxx = first_executable({
  clang_fork_root .. "/bin/clang++",
  vim.fn.exepath("clang++"),
})
local clangd_cmd = {
  clangd,
  "--background-index",
  "--clang-tidy",
  "--completion-style=detailed",
  "--experimental-modules-support",
  "--header-insertion=never",
}

if clangxx ~= "" then
  table.insert(clangd_cmd, "--query-driver=" .. clangxx)
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          flags = {
            debounce_text_changes = 150,
          },
          cmd = clangd ~= "" and clangd_cmd or nil,
        },
      },
    },
  },
}
