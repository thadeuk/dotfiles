require("trouble").setup()

vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>xr", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
  {silent = true, noremap = true}
)
