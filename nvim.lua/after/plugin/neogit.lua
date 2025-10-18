require('neogit').setup {
  kind = "floating",     -- opens it in a floating panel over current buffer
  popup = { kind = "floating" },
  commit_popup = { kind = "floating" },
  rebase_popup = { kind = "floating" },
    rebase_editor = {
    kind = "floating",
  },
  preview_buffer = { kind = "floating" },

  integrations = { diffview = true },
  disable_insert_on_commit = true,
  signs = {
    section = { "", "" },
    item    = { "", "" },
  },
}

vim.keymap.set('n', '<leader>gg', function()
  require('neogit').open({ kind = "floating" })
end)

vim.keymap.set('n', '<leader>gG', function()
  require('neogit').open({ kind = "vsplit" })
end, { desc = "Status (vsplit)" })
