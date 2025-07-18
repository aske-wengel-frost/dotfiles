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
alias book="rustup doc --book"

function smart_open_widget() {
  local target
  target=$(fd -H -t d . | fzf) || return 

  [[ -z "$target" ]] && return
  cd "$target" && ls 
  
  zle reset-prompt
}

zle -N smart_open_widget
bindkey "^f" smart_open_widget

export JAVA_HOME="/opt/homebrew/opt/openjdk@21"
export PATH="$JAVA_HOME/bin:$PATH"
export CPPFLAGS="-I$JAVA_HOME/include"


# manpage highlighting
eval "$(batman --export-env)"
