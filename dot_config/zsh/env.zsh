# env.zsh
# loads environment files when you cd around
# TODO: figure out what was sourced by loading these files, then unset them all
# when the function runs again
# TODO: store the sourced files and watch them for changes. if they change,
# re-load the env

DEBUG=0

log() {
  if [ $DEBUG -eq 0 ]; then
    return
  fi

  echo $@
}

load_env() {
  log "loading env"

  # if we're not in a child of $HOME, exit
  if [[ $PWD/ != ~/* ]]; then
    return
  fi

  # find all the env files between here and home
  local env_files=()

  local dir="$(pwd)"
  while true; do
    log "loading files from $dir"
    env_files+=($dir/.env*(.N))
    log "file list: ${env_files[@]}"

    if [[ "$dir" == ~ ]]; then
      log "exiting"
      break
    fi

    dir="$(dirname "$dir")"
    log "moving up to $dir"
  done

  # work through the files, from furthest (end of the array) to closest (start
  # of the array) so that closely-defined variables overwrite everything

  # automatically export everything that's sourced
  setopt localoptions allexport

  # the (0a) reverses the array
  for file in ${(Oa)env_files}; do
    source $file
  done
}

autoload -U add-zsh-hook
add-zsh-hook chpwd load_env

load_env
