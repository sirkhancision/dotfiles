# edit if you use sudo
su_cmd="doas"

#######################################
#                 XBPS                #
#######################################

# some others are already set by the xtools package
alias xalt="$su_cmd xbps-alternatives -s"
alias xalts="$su_cmd xbps-alternatives -l"
alias xclean="$su_cmd xbps-remove -Oo"
alias xdb="xbps-pkgdb"
alias xdba="xbps-pkgdb -a"
alias xf="xbps-fetch"
alias xqh="xbps-query -H"
alias xqo="xbps-query -O"
alias xr="$su_cmd xbps-remove"
alias xrc="$su_cmd xbps-reconfigure"
alias xrca="$su_cmd xbps-reconfigure -a"
alias xrr="$su_cmd xbps-remove -R"
alias xrsr="xbps-query --regex -Rs"
alias xu="$su_cmd xbps-install -Su"
alias xuu="xbps-src-update"
alias xver="xbps-checkvers -If%n %r -> %s"

#######################################
#               SERVICES              #
#######################################

_sv_enable_completion() {
	local services
	services=$(ls /etc/sv/ | awk -F '/' '{print $NF}')

	COMPREPLY=($(compgen -W "${services[*]}" -- "${COMP_WORDS[COMP_CWORD]}"))
}

sv-enable() {
	_sv_enable_completion

	if [[ $# == 1 ]] && [[ -d /etc/sv/$1 ]]; then
		$su_cmd ln -s /etc/sv/$1 /var/service
	elif [[ ! -d /etc/sv/$1 ]]; then
		echo "Error: service doesn't exist"
		return 1
	elif [[ $# == 0 ]]; then
		echo "Error: name of service needed"
		return 1
	fi
}

_sv_disable_completion() {
	local services
	services=$(ls /var/service/ | awk -F '/' '{print $NF}')

	COMPREPLY=($(compgen -W "${services[*]}" -- "${COMP_WORDS[COMP_CWORD]}"))
}

sv-disable() {
	_sv_disable_completion

	if [[ $# == 1 ]] && [[ -L /var/service/$1 ]]; then
		$su_cmd rm -rf /var/service/$1
	elif [[ ! -L /var/service/$1 ]]; then
		echo "Error: service is not enabled"
		return 1
	elif [[ $# == 0 ]]; then
		echo "Error: name of service needed"
		return 1
	fi
}

complete -F _sv_enable_completion sv-enable
complete -F _sv_disable_completion sv-disable
