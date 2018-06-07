#!/bin/bash
exec 2>/dev/null

# Récupération de l'ID de la dernière quote en ligne
lastquote=$(curl -s https://danstonchat.com/latest.html \
  | hxnormalize -x \
  | hxselect 'div.item h3' \
  | grep -Po -m 1 '\d*(?=\.html)' \
  | head -1)

echo $lastquote

randomID=$(( $RANDOM % $lastquote))

echo $randomID

# curl -s https://danstonchat.com/2960.html \
#   | hxnormalize -x \
#   | hxselect -s '\n' 'div.item-content' \
#   | w3m -dump -cols 2000 -T 'text/html' \
