#---[ Antidote ]-----------------------------------------------------
ANTIDOTE_DIR="${ZDOTDIR:-$HOME}/.antidote"

if [[ ! -d "$ANTIDOTE_DIR" ]]; then
    echo "Installing Antidote..."
    git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_DIR"
fi

source "$ANTIDOTE_DIR/antidote.zsh"
antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins.txt


#---[ Starship ]-----------------------------------------------------
(( ${+commands[starship]} )) && eval "$(starship init zsh)"


#---[ Preferences ]--------------------------------------------------
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

setopt HIST_IGNORE_DUPS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY


#---[ Aliases ]------------------------------------------------------
# Replacements
calias() { if (( ${+commands[${2%% *}]} )); then alias $1=$2; fi }
calias cat "bat"
calias ls "eza --icons=always"

# NeoVim
alias n="nvim"
alias sn="sudo -Es nvim"

# Abbreviations
alias ff="clear && fastfetch"
alias ..="cd .."
alias -g G="| grep"

# Other
alias zrephist="strings ~/.zsh_history > ~/.zsh_history"


#---[ Binds ]--------------------------------------------------------
bindkey "^H" backward-kill-word


#---[ Plugin Configuration ]-----------------------------------------
ZSH_AUTOSUGGEST_STRATEGY=(history completion)


#---[ Yazi ]---------------------------------------------------------
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
