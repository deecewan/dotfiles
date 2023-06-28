#!/usr/bin/env zsh

function funcs#set_desktop() {
  defaults write com.apple.finder CreateDesktop "$1"
  killall Finder
}

function desktop.hide() {
  funcs#set_desktop 0
}

function desktop.show() {
  funcs#set_desktop 1
}

function desktop.toggle() {
  if [[ $(defaults read com.apple.finder CreateDesktop) -eq "0" ]]; then
    desktop.show
  else
    desktop.hide
  fi
}
