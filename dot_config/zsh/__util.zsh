util.source_if_exists() {
  local file="$1"

  [ -f "$file" ] && source "$file"
}
