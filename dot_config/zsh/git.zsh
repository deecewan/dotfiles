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

function git-background-fetch() {
  function inner() {
    local repo_root; repo_root="$(git rev-parse --show-toplevel)"
    if (( $? != 0 )); then
      # bail if we're not in a repo
      return
    fi
    local test_file; test_file="${repo_root}/.git/FETCH_HEAD"

    local last_fetched_delta; last_fetched_delta="$(perl -l -e 'print 86400 * -M $ARGV[0]' ${test_file})"

    # fetch if we last fetched > 1 minute ago
    if (( $last_fetched_delta > 60 )); then
      git fetch
    fi
  }

  ( inner > /dev/null 2>&1 & )
}

autoload -U add-zsh-hook
add-zsh-hook precmd git-background-fetch
