local clangd = vim.fn.exepath("clangd")
local clangxx = vim.fn.exepath("clang++")
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
