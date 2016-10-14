#!/bin/bash
# 2015 copyleft "Serban Teodorescu <teodorescu.serban@gmail.com>"

if [ -z $EDITOR ]; then
  which mcedit > /dev/null
  if [ $? -eq 0 ]; then
    EDITOR=mcedit
  else
    which nano > /dev/null
    if [ $? -eq 0 ]; then
      EDITOR=mcedit
    else
      EDITOR=vi
    fi
  fi
fi

if [ "$1" != "-s" ]; then
  echo "Skipping configure."
else
  echo "Please customize the vars."
  echo "At least the prefix I would guess,"
  read -p "Press any key to start $EDITOR. " -n 1 -r
  $EDITOR vars
fi

echo "Creating / refreshing docker-compose configuration file and env files..."

python config.py

echo "Done. Run me again after any changes in vars file."
echo "You are ready to start the environment!"
echo "Remember to use my rc-docker shortcuts (just type source rc-docker)."
