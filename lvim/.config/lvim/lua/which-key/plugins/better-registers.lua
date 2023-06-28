---@type Plugin
local M = {}

M.name = "better-registers"

M.actions = {
	{ trigger = '"',     mode = "n" },
	{ trigger = '"',     mode = "v" },
	-- { trigger = "@", mode = "n" },
	{ trigger = "<c-r>", mode = "i" },
	{ trigger = "<c-r>", mode = "c" },
}

function M.setup(_wk, _config, options) end

M.registers = '"-:.%/#=_abcdefghijklmnopqrstuvwxyz0123456789'

local labels = {
	['"'] = "last deleted, changed, or yanked content",
	["0"] = "last yank",
	["-"] = "deleted or changed content smaller than one line",
	["."] = "last inserted text",
	["%"] = "name of the current file",
	[":"] = "most recent executed command",
	["#"] = "alternate buffer",
	["="] = "result of an expression",
	["+"] = "synchronized with the system clipboard",
	["*"] = "synchronized with the selection clipboard",
	["_"] = "black hole",
	["/"] = "last search pattern",
	['a'] = "quit",
}

---@type Plugin
---@return PluginItem[]
function M.run(_trigger, _mode, _buf)
	local items = {}

	for i = 1, #M.registers, 1 do
		local key = M.registers:sub(i, i)
		local ok, value = pcall(vim.fn.getreg, key, 1)
		if not ok then
			value = ""
		end

		local _, reginfo = pcall(vim.fn.getreginfo, key)
		reginfo = reginfo or {}
		local type = reginfo.regtype or ""
		if type == '' then
			type = '  '
		elseif type == 'v' then
			type = 'ᶜ '
		elseif type == 'V' then
			type = 'ˡ '
		else
			type = 'ᵇ '
		end

		if value ~= "" then
			value = value:gsub("^%s*", "")
			value = value:gsub("%s*$", "")
			value = value:gsub("\t", " ")
			value = value:gsub("\r\n", "⏎")
			value = value:gsub("\n", "⏎")
			value = value:gsub("\r", "⏎")
			table.insert(items, {
				key = key,
				label = labels[key] or "",
				value = type .. value,
				highlights = { { 1, 2, "Number" } }
			})
		end
	end
	return items
end

return M
