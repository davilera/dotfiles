local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		'git',
		'clone',
		'--depth',
		'1',
		'https://github.com/wbthomason/packer.nvim',
		install_path,
	})
	print('Installing packer... Close and reopen Neovim when done')
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
augroup packer_user_config
autocmd!
autocmd BufWritePost plugins.lua source <afile> | PackerSync
augroup end
]])

-- Use a protected call so we don't error out on first use
local ok, packer = pcall(require, 'packer')
if not ok then
	vim.notify('Plugin manager not found.')
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require('packer.util').float({ border = 'rounded' })
		end,
	},
})

-- Install your plugins here
return packer.startup(function(use)
	-- Generic plugins
	use('wbthomason/packer.nvim') -- Have packer manage itself
	use('nvim-lua/popup.nvim') -- An implementation of the Popup API from vim in Neovim
	use('nvim-lua/plenary.nvim') -- Useful lua functions used ny lots of plugins
	use('lewis6991/impatient.nvim') -- Speed up loading Lua modules
	use('FotiadisM/tabset.nvim') -- Set tab behavior per file type

	-- Nice utilities
	use('NTBBloodbath/color-converter.nvim') -- HEX to RGB to HSL converter
	use('brenoprata10/nvim-highlight-colors') -- Color preview
	use('numToStr/Comment.nvim') -- Easily comment stuff
	use('lewis6991/gitsigns.nvim') -- Git
	use('johmsalas/text-case.nvim') -- Text case conversions
	use('folke/which-key.nvim') -- Show Leader keymaps

	-- Colorschemes
	use('folke/tokyonight.nvim')

	-- Completion plugin and extensions
	use('hrsh7th/nvim-cmp')
	use('hrsh7th/cmp-buffer')
	use('hrsh7th/cmp-path')
	use('hrsh7th/cmp-cmdline')
	use('saadparwaiz1/cmp_luasnip')
	use('hrsh7th/cmp-nvim-lsp')
	use('hrsh7th/cmp-nvim-lua')

	-- Snippets
	use('L3MON4D3/LuaSnip')

	-- LSP
	use('neovim/nvim-lspconfig')
	use('williamboman/mason.nvim')
	use('williamboman/mason-lspconfig.nvim')
	use('jose-elias-alvarez/null-ls.nvim')

	-- Telescope
	use('nvim-telescope/telescope.nvim')

	-- Treesitter
	use({ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' })
	use('JoosepAlviste/nvim-ts-context-commentstring')

	-- IDE look and feel
	use('kyazdani42/nvim-tree.lua') -- File explorer
	use('kyazdani42/nvim-web-devicons') -- File explorer icons
	use('akinsho/bufferline.nvim') -- Tabs
	use('moll/vim-bbye') -- Close tabs

	-- Automatically set up your configuration after cloning packer.nvim
	if PACKER_BOOTSTRAP then
		require('packer').sync()
	end
end)
