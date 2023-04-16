autoload -U colors && colors

alias gs="git status"
alias gst="git status"
alias gsw="git switch"
alias gd="git diff"
alias gds="gd --staged"

function git-hub-clone() {
  if [ $# -ne 1 ]; then
    echo "${fg_bold[red]}ERROR:${reset_color} missing repo"
    echo
    echo "Usage:"
    echo "  git-hub-clone <repo slug>"
    return 1
  fi

  local repo="git@github.com:$1.git"
  local location="$HOME/projects/$1"
  echo "Cloning ${repo} to ${location}"

  git clone "$repo" "$location"
  pushd "$location" || return 1
}
