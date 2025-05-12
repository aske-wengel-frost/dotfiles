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

  target=$(fd . --type f --type d --hidden --exclude .git | \
    fzf --height=100% --reverse --preview '
      if [ -d {} ]; then
        tree -C {} | head -100
      else
        bat --style=numbers --color=always {} 2>/dev/null || cat {}
      fi
    ' --preview-window=right:50%)

  [[ -z "$target" ]] && return

  if [[ -d "$target" ]]; then
    cd "$target"
    zle reset-prompt
  elif [[ "$target" == *.pdf ]]; then
    open "$target"
  elif [[ "$target" =~ \.(py|js|ts|cpp|c|go|rb|sh|rs|java|html|css|md)$ ]]; then
    nvim "$target"
  else
    open "$target"
  fi
}

zle -N smart_open_widget
bindkey "^f" smart_open_widget
