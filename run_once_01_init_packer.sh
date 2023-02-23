#!/usr/bin/env bash

echo "Initializing packer for neovim..."
location="$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
if [[ ! -d "$location" ]]; then
  git clone --depth 1 https://github.com/wbthomason/packer.nvim "$location"
fi

nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
echo "Done!"
