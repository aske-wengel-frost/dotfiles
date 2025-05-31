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
alias wtr="curl http://wttr.in/Odense"

function smart_open_widget() {
  local target

  target=$(fd . --type f --type d --hidden --exclude .git |
    fzf --height=100% --reverse --preview '
      if [ -d {} ]; then
        ls -l --color=always {} | head -50
      else
        bat --style=numbers --color=always --line-range :100 {} 2>/dev/null || head -100 {}
      fi
    ' --preview-window=right:50%)

  [[ -z "$target" ]] && return

  if [[ -d "$target" ]]; then
    cd "$target"
    zle reset-prompt
  elif [[ "$target" == *.pdf ]]; then
    zathura "$target"
  elif [[ "$target" =~ \.(py|js|ts|cpp|c|go|rb|sh|rs|java|html|css|md)$ ]]; then
    nvim "$target"
  else
    open "$target"
  fi
}

zle -N smart_open_widget
bindkey "^f" smart_open_widget

export JAVA_HOME="/opt/homebrew/opt/openjdk@21"
export PATH="$JAVA_HOME/bin:$PATH"
export CPPFLAGS="-I$JAVA_HOME/include"

