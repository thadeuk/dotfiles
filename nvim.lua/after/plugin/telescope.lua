local builtin = require('telescope.builtin')

vim.keymap.set('n', '<C-p>', function()
  require('telescope.builtin').find_files({
    hidden = true,
    no_ignore = true, -- override .gitignore (to see .env)
    file_ignore_patterns = {
      "^.git/",       -- ignore .git folder
      "node_modules", -- ignore node_modules
      "dist/",        -- ignore dist/ foulder
      "%.cache/",     -- ignore .cache
    },
  })
end)

vim.keymap.set('n', '<C-f>', function()
  builtin.grep_string({
    search = vim.fn.input("Grep > "),
    hidden = true,
    no_ignore = true, -- override .gitignore (to see .env)
    file_ignore_patterns = {
      "node_modules",
      "dist/",
      "%.git/",
      "%.cache/",
    },
  })
end)

vim.keymap.set('n', '<leader>*', function()
  builtin.grep_string({
    hidden = true,
    no_ignore = true,
    file_ignore_patterns = {
      "node_modules",
      "dist/",
      "%.git/",
      "%.cache/",
    },
  })
end)

-- Telescope git keybindings
vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = "Git status (modified files)" })
vim.keymap.set('n', '<leader>gl', builtin.git_commits, { desc = "Git commits (full history)" })
vim.keymap.set('n', '<leader>gh', builtin.git_bcommits, { desc = "Git log (current file history)" })
vim.keymap.set('n', '<leader>gb', builtin.git_branches, { desc = "Git branches" })
