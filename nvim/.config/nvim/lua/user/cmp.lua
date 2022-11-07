local cmp_ok, cmp = pcall( require, 'cmp' )
if not cmp_ok then
	return
end

local luasnip_ok, luasnip = pcall( require, 'luasnip' )
if not luasnip_ok then
	return
end

-- Icons from Fira Code at ryanoasis/nerd-fonts
local kind_icons = {
	Text = "",
	Method = "m",
	Function = "",
	Constructor = "",
	Field = "",
	Variable = "",
	Class = "",
	Interface = "",
	Module = "",
	Property = "",
	Unit = "",
	Value = "",
	Enum = "",
	Keyword = "",
	Snippet = "",
	Color = "",
	File = "",
	Reference = "",
	Folder = "",
	EnumMember = "",
	Constant = "",
	Struct = "",
	Event = "",
	Operator = "",
	TypeParameter = "",
}

-- Startup
cmp.setup {

	snippet = {
		expand = function( args )
			luasnip.lsp_expand( args.body )
		end,
	},

	mapping = {
		[ '<C-n>' ] = cmp.config.disable,
		[ '<C-p>' ] = cmp.config.disable,
		[ '<C-y>' ] = cmp.config.disable,

		[ '<Up>' ] = cmp.mapping.select_prev_item(),
		[ '<Down>' ] = cmp.mapping.select_next_item(),
		[ '<C-k>' ] = cmp.mapping( cmp.mapping.scroll_docs( -1 ), { 'i', 'c' } ),
		[ '<C-j>' ] = cmp.mapping( cmp.mapping.scroll_docs( 1 ), { 'i', 'c' } ),
		[ '<C-e>' ] = cmp.mapping {
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		},

		[ '<C-Space>' ] = cmp.mapping( cmp.mapping.complete(), { 'i', 'c' } ),
		[ '<Tab>' ]     = cmp.mapping(
			function( fallback )
				if luasnip.expandable() then
					luasnip.expand()
				elseif luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				elseif cmp.visible() then
					cmp.confirm( { select = true } )
				else
					fallback()
				end
			end,
			{ 'i', 's' }
		),
		[ '<S-Tab>' ]   = cmp.mapping(
			function( fallback )
				if luasnip.jumpable( -1 ) then
					luasnip.jump( -1 )
				else
					fallback()
				end
			end,
			{ 'i', 's' }
		),
	},

	formatting = {
		fields = { 'kind', 'abbr', 'menu' },
		format = function( entry, vim_item )
			vim_item.kind = string.format( '%s', kind_icons[ vim_item.kind ] )
			vim_item.menu = ( {
				nvim_lsp = '[LSP]',
				nvim_lua = '[Neovim]',
				luasnip  = '[Snippet]',
				buffer   = '[Buffer]',
				path     = '[Path]',
			} )[ entry.source.name ]
			return vim_item
		end,
	},

	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'nvim_lua' },
		{ name = 'luasnip' },
		{ name = 'buffer' },
		{ name = 'path' },
	},

	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select   = false,
	},

	window = {
		documentation = {
			border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
		},
	},

	experimental = {
		ghost_text  = true,
		native_menu = false,
	},
}
