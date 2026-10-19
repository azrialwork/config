# Termux shell.
# Prompt: <path> [<branch>] $

# Prompt width caps, in characters.
# Worst case stays around 36 columns.
__PROMPT_PATH_MAX=20
__PROMPT_BRANCH_MAX=10

# --- cursor ---
# DECSCUSR 5 = blinking bar.
# Re-set every prompt: other apps
# tend to leave it on a block.
__cursor_bar() {
  printf '\033[5 q'
}

# --- prompt ---
__prompt_status=0
__prompt_path_text=
__prompt_branch_text=

# Branch straight from .git/HEAD, no
# git process. Detached = 7-char sha.
__prompt_set_branch() {
  local dir=$PWD head
  __prompt_branch_text=

  while [[ -n $dir && $dir != / ]]; do
    if [[ -r $dir/.git/HEAD ]]; then
      read -r head < "$dir/.git/HEAD" || return
      if [[ $head == "ref: refs/heads/"* ]]; then
        __prompt_branch_text=${head#ref: refs/heads/}
      else
        __prompt_branch_text=${head:0:7}
      fi
      return
    fi
    dir=${dir%/*}
  done
}

# $HOME becomes ~.
# Do not use ${PWD/#$HOME/~}: the ~ in
# the replacement expands back to
# $HOME, so it silently does nothing.
# Long paths keep the last directory.
__prompt_set_path() {
  local path=$PWD base
  local keep=$(( __PROMPT_PATH_MAX - 3 ))

  if [[ $path == "$HOME" ]]; then
    path="~"
  elif [[ $path == "$HOME"/* ]]; then
    path="~${path#"$HOME"}"
  fi

  if (( ${#path} > __PROMPT_PATH_MAX )); then
    base=${path##*/}
    if (( ${#base} > keep )); then
      base="${base:0:keep}…"
    fi
    path="…/${base}"
  fi

  __prompt_path_text=$path
}

# \[ \] = zero-width escapes.
# \$ = $ normally, # as root.
__prompt_render() {
  __prompt_set_path
  __prompt_set_branch

  local keep=$(( __PROMPT_BRANCH_MAX - 1 ))
  local accent=32                     # green
  local branch=$__prompt_branch_text

  # Failed command -> red $.
  (( __prompt_status )) && accent=31

  if (( ${#branch} > __PROMPT_BRANCH_MAX )); then
    branch="${branch:0:keep}…"
  fi

  PS1="\[\e[1;33m\]${__prompt_path_text}\[\e[0m\]"
  [[ -n $branch ]] &&
    PS1+=" \[\e[32m\][${branch}]\[\e[0m\]"
  PS1+=" \[\e[1;${accent}m\]"
  PS1+='\$'
  PS1+='\[\e[0m\] '
}

# --- wiring ---
if [[ $- == *i* ]]; then
  __cursor_bar
  # $? must be captured first.
  PROMPT_COMMAND='__prompt_status=$?; '
  PROMPT_COMMAND+='__cursor_bar; '
  PROMPT_COMMAND+='__prompt_render'
fi

# --- alias ---
alias l="ls"
alias ll="ls -a"
alias ..="cd .."
alias ...="cd ../.."
alias oo="opencode --auto"
alias oc="cd ~/.config/opencode"
alias r="source ~/.bashrc && clear"
alias c="r"
