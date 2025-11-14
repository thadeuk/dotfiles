-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }

  use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
  use("nvim-treesitter/nvim-treesitter-context") -- show code context at top

  use {
    "nvim-neo-tree/neo-tree.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    }
  }

  use('neovim/nvim-lspconfig')
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
    }
  }

  -- Formatting and linting on save
  use('nvimtools/none-ls.nvim')
  use('MunifTanjim/prettier.nvim')

  use('lewis6991/gitsigns.nvim')        -- git decorations in the sign column
  use("mbbill/undotree")                -- undo history visualizer - <leader>u to toggle
  use("folke/trouble.nvim")             -- <leader>xx to toggle

  use("folke/zen-mode.nvim")            -- zen mode for distraction free coding
  use("github/copilot.vim")             -- GitHub Copilot
  use("eandrju/cellular-automaton.nvim") -- cellular automaton animations. Use :CellularAutomaton make_it_rain|game_of_life|scramble

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
    requires = { 'nvim-tree/nvim-web-devicons' }
  }

  -- Tabline
  use { 'romgrk/barbar.nvim', requires = {
    'lewis6991/gitsigns.nvim',   -- OPTIONAL: for git status
    'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
  } }

  -- commenter (gcc command for toggle)
  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }

  use("vim-test/vim-test")

  use 'wakatime/vim-wakatime'

  use 'f-person/git-blame.nvim'

  use({
    'NeogitOrg/neogit',
    requires = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim', -- adds commit/diff review panels
    },
  })

  use({
    'MeanderingProgrammer/render-markdown.nvim',
    after = { 'nvim-treesitter' },
    requires = { 'nvim-mini/mini.nvim', opt = true }, -- if you use the mini.nvim suite
    -- requires = { 'nvim-mini/mini.icons', opt = true },        -- if you use standalone mini plugins
    -- requires = { 'nvim-tree/nvim-web-devicons', opt = true }, -- if you prefer nvim-web-devicons
    config = function()
      require('render-markdown').setup({})
    end,
  })
end)
