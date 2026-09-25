return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "cmakelang" },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        asm = { "asmfmt" },
        cmake = { "cmake_format" },
        c = { "clang_format" },
        cpp = { "clang_format" },
      },
      format_on_save = function(bufnr)
        local filetype = vim.bo[bufnr].filetype
        if filetype == "c" or filetype == "cpp" then
          return { timeout_ms = 500, lsp_fallback = true }
        end
      end,
    },
  },
}
