-- nvim-treesitter `main` branch configuration.
-- The `main` branch is a rewrite that drops the old modules/configs system.
-- Highlighting is not enabled automatically: we install parsers, then start
-- treesitter for each buffer whose parser is available via a FileType autocmd.

local parsers = {
  "bash", "c", "css", "diff", "dockerfile", "go", "gomod", "gosum",
  "html", "javascript", "json", "lua", "markdown",
  "markdown_inline", "python", "query", "rust", "sql", "toml",
  "tsx", "typescript", "vim", "vimdoc", "vue", "yaml",
}

require("nvim-treesitter").install(parsers)

-- Use the `json` parser for the `jsonc` filetype (no separate jsonc parser).
vim.treesitter.language.register("json", "jsonc")

vim.api.nvim_create_autocmd("FileType", {
  callback = function(ev)
    pcall(vim.treesitter.start, ev.buf)
  end,
})
