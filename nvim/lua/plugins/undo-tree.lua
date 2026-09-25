return {
  {
    "jiaoshijie/undotree",
    keys = { -- load the plugin only when using it's keybinding:
      { "<leader>u<leader>", "<cmd>lua require('undotree').toggle()<cr>" },
    },
  },
}
