local repo_folder="$HOME/.config/zsh/plugins"

declare -a used_plugins

zsh.update_plugins() {
  for folder in $repo_folder/*/*; do
    echo "Updating $folder"

    pushd "$folder"
    git pull
    popd
  done

  echo "Updated...restart shell to use new updated"
}

zsh.clean_unused_plugins() {
  # after all the `add_plugin` calls
  declare -a unused_plugins
  for folder in $repo_folder/*/*; do
    if ! (($used_plugins[(Ie)$folder])); then
      unused_plugins+=("$folder")
    fi
  done

  local count="${#unused_plugins}"
  if [ "$count" -gt 0 ]; then
    local plugin="plugin";
    local appear="appear";

    if (($count > 1)); then
      plugin+="s"
    else
      appear+="s"
    fi

    echo "The following $plugin $appear unsued:"
    for p ($unused_plugins); do
      echo "  - $p"
    done

    if read -q "tmp?Do you want to remove them locally? "; then
      echo "\n"

      for p ($unused_plugins); do
        rm -fr "$p"
      done
    fi
  fi
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
  used_plugins+=("$local_repo")

  if [ ! -d "$local_repo" ]; then
    echo "Missing repo '$repo'..."
    git clone "$repo" "$local_repo"
  fi

  source "$local_repo/$plugin_file"
}

add_plugin "https://github.com/zsh-users/zsh-completions"
add_plugin "https://github.com/z-shell/F-Sy-H"

# needed for pure
fpath+=($(get_repo_path "https://github.com/sindresorhus/pure"))
add_plugin "https://github.com/sindresorhus/pure"

zsh.clean_unused_plugins

autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
  compdump
done

compinit -C
