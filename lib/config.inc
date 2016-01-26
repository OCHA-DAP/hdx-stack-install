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

echo "Please customize the vars."
echo "At least the domain I would guess,"
read -p "Press any key to start $EDITOR. " -n 1 -r
$EDITOR vars

echo "Creating docker-compose configuration file and env files..."

python config.py

#source vars

#envsubst < common.tpl > common.yml

#for f in $(ls env_*.tpl | sed -e 's/\.tpl$//'); do
#    envsubst < $f.tpl > $f
#    sed -i 's/%/$/' $f
#done

echo "Done. Run me again after any changes in vars file."
echo "You are ready to start the environment!"
