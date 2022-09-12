main() {
  local cloud_sdk_root; cloud_sdk_root="$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk"

  if [ -d "$cloud_sdk_root" ]; then
    source "$cloud_sdk_root/path.zsh.inc"
    source "$cloud_sdk_root/completion.zsh.inc"
  fi
}

main
