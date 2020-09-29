" Kitty customizations.
if $TERM != 'xterm-kitty'
	finish
end

" Fix background bug with Kitty.
let &t_ut=''
