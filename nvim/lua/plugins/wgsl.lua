return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "wgsl",
      },
    },
  },

  {
    "nvim-lua/plenary.nvim",
    init = function()
      vim.filetype.add({
        extension = {
          wgsl = "wgsl",
          wesl = "wgsl",
        },
      })
    end,
  },
}
