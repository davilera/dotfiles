local function getPhpcbfStandard()
	if 0 == vim.fn.filereadable('./phpcs.ruleset.xml') then
		return "--standard=WordPress"
	else
		return "--standard=phpcs.ruleset.xml"
	end
end

return {
	{
		"stevearc/conform.nvim",
		opts = {
			formatters = {
				prettier = {
					command = vim.env.HOME .. "/.nvm/versions/node/v20.12.2/bin/prettier",
				},
				phpcbf = {
					command = vim.env.HOME .. "/.config/composer/vendor/bin/phpcbf",
					args = {
						"-q",
						"--stdin-path=$FILENAME",
						getPhpcbfStandard(),
						"-",
					},
				},
				stylelint = {
					command = "stylelint",
					args = { "--fix" },
				},
			},
			formatters_by_ft = {
				php = { "phpcbf" },
				css = { "stylelint" },
				scss = { "stylelint" },
			},
		},
	},
}
