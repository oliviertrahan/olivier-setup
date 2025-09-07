#!/bin/bash
restart_file=$HOME/.nvim-restart.flag
flags="$@"
while true; do
  nvim $flags
  if [ -f $restart_file ]; then
    IFS=$'\n' read -r -a flags < $restart_file
    rm $restart_file
    continue
  fi
  break
done
