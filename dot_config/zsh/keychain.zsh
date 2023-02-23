eval "$(keychain --eval --agents ssh id_rsa)"

util.source_if_exists "~/.keychain/$HOST-sh"
util.source_if_exists "~/.keychain/$HOST-sh-gpg"
