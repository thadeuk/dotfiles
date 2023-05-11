require("neo-tree").setup({
	close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
	popup_border_style = "rounded",
	enable_git_status = true,
	event_handlers = {
		{
			event = "file_opened",
			handler = function(file_path)
				--auto close
				require("neo-tree").close_all()
			end
		},
	}
})

vim.cmd([[nnoremap <C-e> :Neotree float <cr>]])
vim.cmd([[nnoremap <C-g> :Neotree float git_status <cr>]])
