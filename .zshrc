# oh-my-zsh setup 
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# aliases 
alias vim="nvim"
alias v="nvim"
alias lg="lazygit"
alias o="open"
alias wtr="curl http://wttr.in/Kerteminde"
alias cal="icalbuddy eventsToday"
alias rustBook="rustup doc --book"
alias eTerm="nvim ~/Library/Application\ Support/com.mitchellh.ghostty/config" 
alias getAlias="grep -w 'alias' ~/.zshrc"

function smart_open_widget() {
  local target
  target=$(fd -t d . --exclude .git --exclude node_modules --exclude venv| fzf) || return 

  [[ -z "$target" ]] && return
  cd "$target" 
  
  zle reset-prompt
}

zle -N smart_open_widget
bindkey "^f" smart_open_widget

export JAVA_HOME="/opt/homebrew/opt/openjdk@21"
export PATH="$JAVA_HOME/bin:$PATH"
export CPPFLAGS="-I$JAVA_HOME/include"


# manpage highlighting
eval "$(batman --export-env)"
export PATH="/opt/homebrew/opt/postgresql@13/bin:$PATH"


#python3 paths
export LDFLAGS="-L/opt/homebrew/opt/tcl-tk/lib"
export CPPFLAGS="-I/opt/homebrew/opt/tcl-tk/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/tcl-tk/lib/pkgconfig"

eval "$(pyenv init --path)"
eval "$(pyenv init -)"
