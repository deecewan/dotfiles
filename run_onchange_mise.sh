#!/usr/bin/env zsh

# change the checksum if the mise config changes
# {{ include "dot_config/mise/config.toml" | sha256sum }}

echo "installing mise"

mise install
