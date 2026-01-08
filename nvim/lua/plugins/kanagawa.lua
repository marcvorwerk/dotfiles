return {
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        compile = false, -- optional
        transparent = false, -- wenn du Transparenz willst → true
        theme = "lotus", -- oder: "wave", "dragon", "lotus"
      })

      -- Colorscheme aktivieren
      vim.cmd("colorscheme kanagawa")
    end,
  },
}
