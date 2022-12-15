local status_ok, nvim_tree = pcall(require, 'nvim-tree')
if not status_ok then
	return
end

local config_status_ok, nvim_tree_config = pcall(require, 'nvim-tree.config')
if not config_status_ok then
	return
end

local tree_cb = nvim_tree_config.nvim_tree_callback
nvim_tree.setup({
	actions = {
		change_dir = { restrict_above_cwd = true },
	},
	filters = {
		custom = { '.git', '.lando', 'node_modules', 'vendor', 'build' },
	},
	update_focused_file = {
		enable = true,
		update_cwd = true,
	},
	renderer = {
		root_folder_label = ':t',
		group_empty = true,
		icons = {
			glyphs = {
				default = '',
				symlink = '',
				folder = {
					arrow_open = '',
					arrow_closed = '',
					default = '',
					open = '',
					empty = '',
					empty_open = '',
					symlink = '',
					symlink_open = '',
				},
				git = {
					unstaged = '',
					staged = 'S',
					unmerged = '',
					renamed = '➜',
					untracked = 'U',
					deleted = '',
					ignored = '◌',
				},
			},
		},
	},
	diagnostics = {
		enable = true,
		show_on_dirs = true,
		icons = {
			hint = '',
			info = '',
			warning = '',
			error = '',
		},
	},
	view = {
		width = 30,
		side = 'left',
		mappings = {
			list = {
				{ key = 'l', cb = tree_cb('edit') },
				{ key = { '.', 'h' }, cb = tree_cb('close_node') },
				{ key = 'v', cb = tree_cb('vsplit') },
				{ key = 's', cb = tree_cb('split') },
			},
		},
	},
})

-- -------
-- HELPERS
-- -------

vim.api.nvim_create_user_command('NvimTreeSmartToggle', function()
	local name = vim.api.nvim_buf_get_name(0)
	if string.find(name, 'NvimTree_1') then
		nvim_tree.toggle()
	else
		nvim_tree.open()
	end
end, {})
