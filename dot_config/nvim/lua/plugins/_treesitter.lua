return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install({
        "bash",
        "css",
        "graphql",
        "html",
        "java",
        "javascript",
        "json",
        "json5",
        "jsonc",
        "kotlin",
        "lua",
        "markdown",
        "ruby",
        "rust",
        "tsx",
        "typescript",
        "vim",
        "yaml",
        "markdown_inline",
      })
    end,
  },
  "IndianBoy42/tree-sitter-just",
}
