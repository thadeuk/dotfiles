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
