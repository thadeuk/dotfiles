vim.g.mapleader = " "

-- move entire lines up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- keep cursor centered vertically
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever - paste without yanking
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- vim.keymap.set("n", "<C-Left>", ":tabprevious <CR>")
-- vim.keymap.set("n", "<C-Right>", ":tabnext <CR>")
-- vim.keymap.set("n", "<C-PageDow>fn>", ":execute 'silent! tabmove ' . (tabpagenr()-2)<CR>")
-- vim.keymap.set("n", "<C-PageUp>", ":execute 'silent! tabmove ' . (tabpagenr()+1)<CR>")

vim.keymap.set("n", "<C-]>", '<cmd>tab split | lua vim.lsp.buf.definition()<CR>')

vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>")

vim.keymap.set("n", "<leader>qf", function()
  vim.lsp.buf.code_action({ only = { "quickfix" } })
end, { noremap = true, silent = true, desc = "Quick Fix" })

-- Git keybindings
vim.keymap.set("n", "<leader>gd", ":Gdiffsplit<CR>") -- Diff current file
vim.keymap.set("n", "<leader>gh", ":Gitsigns preview_hunk<CR>")
vim.keymap.set("n", "<leader>gp", ":Gitsigns stage_hunk<CR>")
vim.keymap.set("n", "<leader>gu", ":Gitsigns undo_stage_hunk<CR>")
vim.keymap.set("n", "]g", ":Gitsigns next_hunk<CR>")
vim.keymap.set("n", "[g", ":Gitsigns prev_hunk<CR>")
