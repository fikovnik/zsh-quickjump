__quickjump_zsh_completion() {
  local args cmd slug selected

  args=(${(z)LBUFFER})
  cmd=${args[1]}

  # j - recent dirs
  # f - recent files edit
  # v - recent files visit
  local cmdq
  case "$cmd" in
    "j")
      cmdq=(fasd -Rdl)
      ;;
    "f")
      cmdq=(fasd -Rfl)
      ;;
    "v")
      cmdq=(fasd -Rfl)
      ;;
    *)
      zle ${__quickjump_default_completion:-expand-or-complete}
      return
      ;;
  esac

  if [[ "${#args}" -gt 1 ]]; then
    eval "slug=${args[-1]}"
  fi

  local matches=$("${cmdq[@]}" "$slug")

  local count=$(echo "$matches" | wc -l)
  if [[ $count -gt 1 ]]; then
    cmdf=(sk --prompt="$cmd> " --query="$slug" --tac --no-sort --no-multi --bind "shift-tab:up,tab:down" --reverse --height 40%)
    selected=$(echo "$matches" | $cmdf)
  elif [[ "$count" -eq 1 ]]; then
    selected=$matches
  else;
    return
  fi

  # return completion result with $selected
  if [[ -n "$selected" ]]; then
    selected=$(printf %q "$selected")
    if [ "$cmd" = "j" -a "$selected" != */ ]; then
      selected="${selected}/"
    fi
    LBUFFER="$cmd $selected"
  fi

  zle redisplay
  typeset -f zle-line-init >/dev/null && zle zle-line-init
}

[ -z "$__quickjump_default_completion" ] && {
  binding=$(bindkey '^I')
  [[ $binding =~ 'undefined-key' ]] || __quickjump_default_completion=$binding[(s: :w)2]
  unset binding
}

zle      -N  __quickjump_zsh_completion
bindkey '^I' __quickjump_zsh_completion
