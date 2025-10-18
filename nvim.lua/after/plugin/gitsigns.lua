require('gitsigns').setup {
  signs = {
    add          = { text = '│' },
    change       = { text = '❱' },
    delete       = { text = '' },
    topdelete    = { text = '^' },
    changedelete = { text = '❰' },
    untracked    = { text = '┆' },
  }
}

vim.keymap.set('n', ']g', require('gitsigns').next_hunk)
vim.keymap.set('n', '[g', require('gitsigns').prev_hunk)
vim.keymap.set('n', '<leader>gB', require('gitsigns').blame_line, { desc = "Blame line" })
