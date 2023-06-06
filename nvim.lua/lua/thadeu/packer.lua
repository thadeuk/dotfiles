-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.1',
		-- or                            , branch = '0.1.x',
		requires = { {'nvim-lua/plenary.nvim'} }
	}

	use({ 'rose-pine/neovim', as = 'rose-pine', config = function() 
		vim.cmd('colorscheme rose-pine')
	end })


	use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})

	use {
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		requires = { 
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		}
	}

	use('tpope/vim-fugitive')

	use {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v2.x',
    requires = {
			-- LSP Support
			{'neovim/nvim-lspconfig'},             -- Required
			{                                      -- Optional
			'williamboman/mason.nvim',
			run = function()
				pcall(vim.cmd, 'MasonUpdate')
			end,
		},
		{'williamboman/mason-lspconfig.nvim'}, -- Optional

		-- Autocompletion
		{'hrsh7th/nvim-cmp'},     -- Required
		{'hrsh7th/cmp-nvim-lsp'}, -- Required
		{'L3MON4D3/LuaSnip'},     -- Required

    {'jose-elias-alvarez/null-ls.nvim'}, -- Optional
	}
}

use('lewis6991/gitsigns.nvim')
use("nvim-treesitter/nvim-treesitter-context")
use("mbbill/undotree")
use("folke/trouble.nvim")

use("folke/zen-mode.nvim")
use("github/copilot.vim")
use("eandrju/cellular-automaton.nvim")

-- Colorscheme
use 'folke/tokyonight.nvim'

-- Statusline
use {
  'nvim-lualine/lualine.nvim',
  requires = { 'nvim-tree/nvim-web-devicons', opt = true }
}

-- initial screen, useless
use {
  'glepnir/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    require('dashboard').setup {
      theme = 'hyper',
      config = {
        week_header = {
         enable = true,
        },
       project = { enable = true, limit = 8, icon = ' ', label = ' Recent Projects:', action = 'Telescope find_files cwd=' },
      }
    }
  end,
  requires = {'nvim-tree/nvim-web-devicons'}
}

-- Tabline
use {'romgrk/barbar.nvim', requires = {
  'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
  'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
}}

-- commenter (gcc command for toggle)
use {
    'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup()
    end
}

use("vim-test/vim-test")

end)