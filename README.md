# dotfiles

## Pre-requisites

You'll need 1password

## Getting Started

A one-line to install `chezmoi` and apply the dotfiles.
Installs chezmoi to `./bin` by default. Run from `~`.

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply deecewan
```

Once `chezmoi` is installed, you can set options by editing the
`~/.config/chezmoi/chezmoi.toml` file and changing the options under the
`data.options` key

### Options

All options are false by default

- `android`: enable android development bits
- `gcloud`: enable the google cloud sdk
- `brew`: install homebrew/linuxbrew and packages in the brewfile
