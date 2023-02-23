local repo_folder="$HOME/.config/zsh/plugins"

zsh.update_plugins() {
  for folder in $repo_folder/*; do
    echo "Updating $folder"

    pushd "$folder"
    git pull
    popd
  done

  echo "Updated...restart shell to use new updated"
}

get_repo_path() {
  local repo="$(basename "$1")"
  local org="$(basename "$( dirname $1 )")"

  echo "$repo_folder/$org/$repo"
}

add_plugin() {
  local repo="$1"
  local plugin_file="$(basename "$repo").plugin.zsh"
  local local_repo="$(get_repo_path "$repo")"

  if [ ! -d "$local_repo" ]; then
    echo "Missing repo '$repo'..."
    git clone "$repo" "$local_repo"
  fi

  source "$local_repo/$plugin_file"
}

add_plugin "https://github.com/zsh-users/zsh-completions"
add_plugin "https://github.com/z-shell/F-Sy-H"

add_plugin "https://github.com/sindresorhus/pure"
# needed for pure
fpath+=($(get_repo_path "https://github.com/sindresorhus/pure"))

autoload -Uz compinit; compinit
