function WordPress()

	if !filereadable( ".lando.yml" )
		return
	endif

	let recipe = get( systemlist( "grep 'recipe:.*wordpress' .lando.yml" ), 0, '' )
	let recipe = substitute( recipe, '\s', '', 'g' )
	if recipe != "recipe:wordpress"
		return
	endif

	set syntax=php.wordpress

endfunction

au BufRead,BufNewFile *.php call WordPress()
