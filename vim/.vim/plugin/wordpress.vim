function WordPress()

	if !filereadable( ".lando.yml" )
		return
	endif

	let recipe = trim( system( "grep 'recipe: wordpress' .lando.yml" ) )
	if recipe != "recipe: wordpress"
		return
	endif

	set syntax=php.wordpress

endfunction

au BufRead,BufNewFile *.php call WordPress()
