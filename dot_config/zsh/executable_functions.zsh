#!/usr/bin/env zsh

loki() {
  local filter audit

  zmodload zsh/zutil || return

  zparseopts -D -F -K -- \
    {f,-filter}:=filter \
    {a,-audit}=audit || return

  yarn loki --storiesFilter="${filter[-1]}"
  result=$?

  if (($#audit)); then
    if ((!result)); then
      print 'All tests were successful'
    else
      for f in .loki/difference/*; do
        basename="$(basename "$f")"
        if [[ "$basename" = "*" ]]; then
          echo "nothing to do"
          break
        fi

        echo "$basename:"

        montage -depth 8 -pointsize 32 -geometry +1+0 -label reference .loki/reference/"$basename" -label difference .loki/difference/"$basename" -label current .loki/current/"$basename" - | kitty +kitten icat

        echo "Update the reference?"
        select yn in "Yes" "No"; do
          case $yn in
          Yes)
            cp ".loki/current/$basename" ".loki/reference/$basename"
            rm ".loki/difference/$basename"
            break
            ;;
          No) break ;;
          esac
          break
        done
      done
    fi
  fi
}
