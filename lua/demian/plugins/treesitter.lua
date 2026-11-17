-- Formatting and higlight code according to programming language
-- NOTE: Uses the nvim-treesitter `main` branch (rewrite). It no longer has
-- `nvim-treesitter.configs`; highlighting/indent are enabled per FileType below.
-- Requires the `tree-sitter` CLI (>= 0.26.1) and a C compiler to install parsers.
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false, -- the main branch does not support lazy-loading
  build = ":TSUpdate",
  dependencies = {
    -- auto close/rename html tags (configured on its own now)
    { "windwp/nvim-ts-autotag", opts = {} },
  },
  config = function()
    local ts = require("nvim-treesitter")

    -- ensure these language parsers are installed (no-op if already installed)
    ts.install({
      "json",
      "javascript",
      "typescript",
      "tsx",
      "yaml",
      "html",
      "css",
      "prisma",
      "markdown",
      "markdown_inline",
      "svelte",
      "graphql",
      "bash",
      "lua",
      "vim",
      "dockerfile",
      "gitignore",
      "query",
      "vimdoc",
      "c",
      "python",
    })

    -- enable syntax highlighting and indentation for any buffer with a parser
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("demian_treesitter", { clear = true }),
      callback = function(args)
        if pcall(vim.treesitter.start, args.buf) then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })

    -- incremental selection (built into Neovim 0.12 as `an` / `in` in visual mode)
    vim.keymap.set("n", "<C-space>", "van", { remap = true, desc = "Start treesitter selection" })
    vim.keymap.set("x", "<C-space>", "an", { remap = true, desc = "Expand treesitter selection" })
    vim.keymap.set("x", "<bs>", "in", { remap = true, desc = "Shrink treesitter selection" })
  end,
}
