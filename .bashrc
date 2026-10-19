# ---------------------------------------------------------------------------
# Termux interactive shell
# ---------------------------------------------------------------------------

# Width budgets, in characters. Chosen so the worst-case prompt stays under
# 45 columns, which is roughly the width of a phone in portrait.
__PROMPT_PATH_MAX=20
__PROMPT_BRANCH_MAX=10

# ---------------------------------------------------------------------------
# Cursor
# ---------------------------------------------------------------------------
# DECSCUSR 5 = blinking bar. Some apps leave the terminal on a block cursor,
# so it is re-asserted at startup and again before every prompt.
__cursor_bar() {
  printf '\033[5 q'
}

# ---------------------------------------------------------------------------
# Prompt: <path> [<branch>] $
# ---------------------------------------------------------------------------
__prompt_status=0
__prompt_path_text=
__prompt_branch_text=

# Branch name straight from .git/HEAD, so no git process is started per
# prompt. Detached HEAD shows the short sha instead. Empty outside a repo.
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

# $HOME becomes ~. Written as an explicit prefix test rather than
# ${PWD/#$HOME/~}: the ~ in a substitution's replacement is expanded back
# to $HOME, which silently turns the whole substitution into a no-op.
# Long paths collapse to the last directory, since that is the part that
# tells you where you are.
__prompt_set_path() {
  local path=$PWD base keep=$(( __PROMPT_PATH_MAX - 3 ))
  [[ $path == "$HOME" || $path == "$HOME"/* ]] && path="~${path#"$HOME"}"

  if (( ${#path} > __PROMPT_PATH_MAX )); then
    base=${path##*/}
    (( ${#base} > keep )) && base="${base:0:keep}…"
    path="…/${base}"
  fi

  __prompt_path_text=$path
}

# \[ \] mark escape sequences as zero-width so readline counts columns right.
# \$ renders as $ for a normal user and # for root.
__prompt_render() {
  __prompt_set_path
  __prompt_set_branch

  local accent=32 branch=$__prompt_branch_text   # green by default
  (( __prompt_status )) && accent=31   # red when the last command failed
  (( ${#branch} > __PROMPT_BRANCH_MAX )) &&
    branch="${branch:0:$(( __PROMPT_BRANCH_MAX - 1 ))}…"

  PS1="\[\e[1;33m\]${__prompt_path_text}\[\e[0m\]"
  [[ -n $branch ]] && PS1+=" \[\e[32m\][${branch}]\[\e[0m\]"
  PS1+=" \[\e[1;${accent}m\]"
  PS1+='\$'
  PS1+='\[\e[0m\] '
}

# ---------------------------------------------------------------------------
# Wiring
# ---------------------------------------------------------------------------
if [[ $- == *i* ]]; then
  __cursor_bar
  # $? must be captured first; every later command in the chain overwrites it.
  PROMPT_COMMAND='__prompt_status=$?; __cursor_bar; __prompt_render'
fi
