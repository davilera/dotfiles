# Setup {{{1

[ "$TMUX" == "" ] && TERM=screen-256color-bce tmux && exit;

export PROMPT_COMMAND=__prompt_command

__prompt_command() {
	code=$?
	[[ $code != 0 ]] && echo -e "$RED✗ ${code}${RESET_COLOR}"
	if [ $UID -eq 0 ];
	then
		PS1="$(__ps1_hostname)\[\e[1;34m\]\W\$(__dev_loc)\[\e[0m\]\$(__cvs_info)#\[\e[0m\] "
	else
		PS1="$(__ps1_hostname)\[\e[1;34m\]\W\$(__dev_loc)\[\e[0m\]\$(__cvs_info)$\[\e[0m\] "
	fi
}

__ps1_hostname() {
	host=$(hostname)
	user=$(whoami)
	if [[ "$host" != "helios" || "$user" != "david" ]]; then
		echo -n "\[\e[1;30m\]$user\[\e[0;37m\]@\[\e[1;36m\]$host "
	fi
}

__dev_loc() {
	[[ `pwd | grep "wordpress.org"` ]] && echo -e -n " ${LIGHT_BLUE}wp"
	[[ `pwd | grep "vagrant"` ]] && echo -e -n " ${LIGHT_BLUE}vvv"
}

# Git and SVN helpers {{{2

__cvs_info() {

	[ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1
	[[ $? -eq 0 ]] && echo -n " " && __git_info && return

}

__git_info() {
	branch=`git branch | grep \* | cut -d ' ' -f2`
	echo -e -n "${LIGHT_PURPLE}${branch}${RESET_COLOR}"
}

# Env {{{1
export PATH="$HOME/Programs/bin:$PATH:./node_modules/.bin"

export RED='' #'\033[0;31m'
export YELLOW='' #'\033[1;33m'
export GREEN='' #'\033[0;32m'
export LIGHT_BLUE='' #'\033[0;34m'
export LIGHT_PURPLE='' #'\033[0;35m'
export RESET_COLOR='' #'\033[0m'

export BROWSER=/usr/bin/chromium
export EDITOR=vim
export HISTSIZE=10000
export TIMEFORMAT="=> %E"

# less colors {{{2
export LESS_TERMCAP_mb=$'\e[01;31m' # begin blinking
export LESS_TERMCAP_md=$'\e[01;34m' # begin bold
export LESS_TERMCAP_me=$'\e[0m' # end mode
export LESS_TERMCAP_se=$'\e[0m' # end standout-mode
export LESS_TERMCAP_so=$'\e[01;32m' # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\e[0m' # end underline
export LESS_TERMCAP_us=$'\e[01;36m' # begin underline

if [ -f "/usr/share/virtualenvwrapper/virtualenvwrapper.sh" ];
then
	source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
fi

# Aliases {{{1
alias calc="libreoffice --calc"
alias cleanvim="vim -N -u NONE"
alias draw="libreoffice --draw"
alias duh="du -h -d 0 [^.]*"
alias em="mutt"
alias grep="grep --color"
alias htop="sudo htop"
alias impress="libreoffice --impress"
alias l="ls -al"
alias ls='ls --color=auto'
alias m="vimpc"
alias open="xdg-open"
alias pretty-json="python2 -mjson.tool"
alias screencast="ffmpeg -f alsa -ac 2 -i loopout -f alsa -ac 2 -i hw:2,0 -filter_complex amix=inputs=2:duration=first -f x11grab -r 30 -s 1920x1080 -i :0.0 -acodec aac -vcodec libx264 -crf 0 -preset medium output.mp4"
alias syms="find . -maxdepth 1 -type l -print | while read line; do ls -alc "\$line"; done"
alias usermount="sudo mount -o gid=users,fmask=113,dmask=002"
alias vb="VBoxManage"

alias grep="grep --color --exclude *.min.*"
alias makepot="php ~/Programs/dev/workspaces/nelio/vagrant-local/www/wordpress-develop/tools/i18n/makepot.php"

# Fasd {{{1
eval "$( fasd --init posix-alias bash-hook bash-ccomp bash-ccomp-install )"
alias j="z"
alias jj="zz"
alias v='f -e vim'
