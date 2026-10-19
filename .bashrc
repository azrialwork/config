# Blinking bar cursor (DECSCUSR 5). Some apps leave the terminal on a block
# cursor; re-assert it at startup and after every command.
__cursor_bar() {
  printf '\033[5 q'
}

# Prompt: <path> [<git branch>] $ , exit code shown only when it fails.
__prompt_status=0
__pb=

__prompt_branch() {
  local d=$PWD h
  __pb=
  while [[ -n $d && $d != / ]]; do
    if [[ -r $d/.git/HEAD ]]; then
      read -r h < "$d/.git/HEAD" || return
      if [[ $h == "ref: refs/heads/"* ]]; then
        __pb=${h#ref: refs/heads/}
      else
        __pb=${h:0:7}
      fi
      return
    fi
    d=${d%/*}
  done
}

__prompt_render() {
  local p=$PWD b
  __prompt_branch

  # Shorten $HOME to ~. Do not use ${PWD/#$HOME/~}: the ~ in the replacement
  # gets tilde-expanded back to $HOME, so the substitution silently does nothing.
  [[ $p == "$HOME" || $p == "$HOME"/* ]] && p="~${p#"$HOME"}"

  # Caps chosen so the worst case stays under 45 columns.
  if (( ${#p} > 20 )); then
    b=${p##*/}
    (( ${#b} > 17 )) && b="${b:0:17}…"
    p="…/${b}"
  fi
  [[ -n $__pb && ${#__pb} > 10 ]] && __pb="${__pb:0:9}…"

  PS1="\[\e[1;33m\]${p}\[\e[0m\]"
  [[ -n $__pb ]] && PS1+=" \[\e[32m\][${__pb}]\[\e[0m\]"

  # No error text: a failed command turns the $ red instead.
  local c=32
  (( __prompt_status )) && c=31
  PS1+=" \[\e[1;${c}m\]"
  PS1+='\$'
  PS1+='\[\e[0m\] '
}

if [[ $- == *i* ]]; then
  __cursor_bar
  PROMPT_COMMAND='__prompt_status=$?; __cursor_bar; __prompt_render'
fi
