main() {
  local download_folder="$HOME/.config/zsh/files"

  if [ ! -d "$download_folder" ]; then
    mkdir -p "$download_folder"
  fi

  # Download rupa/z
  download_and_enable https://raw.githubusercontent.com/rupa/z/master/z.sh z.sh
  download_and_enable https://raw.githubusercontent.com/junegunn/fzf-git.sh/main/fzf-git.sh fzf-git.sh
}

download_and_enable() {
  local url="$1"
  local file="$2"
  shift; shift;

  local local_location="$download_folder/$file"

  if [ ! -f "$local_location" ]; then
    echo "Missing file '$file' - downloading from '$url'"
    curl "$url" -o "$local_location"
  fi

  source "$local_location"
}

main
