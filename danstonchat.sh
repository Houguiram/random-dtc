#!/bin/bash
exec 2>/dev/null

while getopts l option
do
case "${option}"
in
l) LAST=1;;
esac
done

lastquote=$(curl -s https://danstonchat.com/latest.html \
  | hxnormalize -x \
  | hxselect 'div.item h3' \
  | grep -Po -m 1 '\d*(?=\.html)' )

displayedquote=""



while  [[  -z  $displayedquote  ]]
do
	if [ "$LAST" = "1" ]
	then
		ID=$lastquote
	else	
		ID=$(( $RANDOM % $lastquote))
	fi
	
	displayedquote=$(curl -s https://danstonchat.com/$ID.html \
	  | hxnormalize -x \
	  | hxselect 'div.item-content' \
	  | w3m -dump -cols 2000 -T 'text/html' )
done 

echo "$displayedquote"

exit 0
