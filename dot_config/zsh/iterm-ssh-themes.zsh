function tabc() {
  NAME=$1; if [ -z "$NAME" ]; then NAME="Default"; fi
  # if you have trouble with this, change
  # "Default" to the name of your default theme
  echo -e "\033]50;SetProfile=$NAME\a"
}

function tab-reset() {
  tabc "Default"
}

function colorssh() {
  if [[ -n "$ITERM_SESSION_ID" ]]; then
    trap "tab-reset" INT EXIT
    tabc SSH
  fi
  ssh $*
}
compdef _ssh tabc=ssh

function colormosh() {
  if [[ -n "$ITERM_SESSION_ID" ]]; then
    trap "tab-reset" INT EXIT
    tabc SSH
  fi
  mosh $*
}
compdef _mosh tabc=mosh

alias ssh="colorssh"
alias mosh="colormosh"
