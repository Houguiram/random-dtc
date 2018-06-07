#!/bin/bash
exec 2>/dev/null

lastquote=$(curl -s https://danstonchat.com/latest.html \
  | hxnormalize -x \
  | hxselect 'div.item h3' \
  | grep -Po -m 1 '\d*(?=\.html)' \
  | head -1)

randomID=$(( $RANDOM % $lastquote))

curl -s https://danstonchat.com/$randomID.html \
  | hxnormalize -x \
  | hxselect -s '\n' 'div.item-content' \
  | w3m -dump -cols 2000 -T 'text/html' \
