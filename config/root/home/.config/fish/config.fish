alias i="paru -S"
alias s="paru -Ss"
alias r="paru -R"

alias nuclear="echo -e '\e[3J' && clear"

abbr --add cat bat # Bat; cat with syntax highlighting
abbr --add ls eza # Eza; ls with symbols
abbr --add cd z # Z; alias for zoxide

alias eza="eza --icons=always" 

zoxide init fish | source # Zoxide; smart CD

set -U fish_greeting ""

if status is-interactive
	fastfetch
	echo
	echo "You cannot learn without mistakes."
	echo "Welcome, $(whoami)."
end
