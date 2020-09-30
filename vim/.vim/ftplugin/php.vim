let b:ale_linters = [ 'phpcs' ]
let b:ale_fixers = [ 'phpcbf' ]

let ruleset='./phpcs.ruleset.xml'
if filereadable(ruleset)
	let b:ale_php_phpcs_standard = ruleset
	let b:ale_php_phpcbf_standard = ruleset
end
unlet ruleset
