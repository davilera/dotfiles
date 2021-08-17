let b:ale_linters = [ 'tsserver', 'eslint' ]
let b:ale_fixers = [ 'prettier', 'eslint' ]

if filereadable('.eslintrc') || filereadable('.eslintrc.js')
	finish
end

let eslintrc = './node_modules/@wordpress/scripts/config/.eslintrc.js'
if filereadable(eslintrc)
	let b:ale_typescript_eslint_options = '-c ' . eslintrc
end
unlet eslintrc
