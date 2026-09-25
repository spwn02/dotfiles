return {
  -- Add Minuet AI for poetry autocomplete below
  {
    "milanglacier/minuet-ai.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("minuet").setup({
        provider = "ollama",
        provider_options = {
          ollama = {
            model = "llama3.1:8b",
            end_point = "http://localhost:11434/v1/chat/completions",
            stream = true,
          },
        },
      })
    end,
  },
}
