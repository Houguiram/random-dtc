#!/bin/bash
exec 2>/dev/null

colorAliases () {
	colored=""
	while read -r line; do
		    colored=$colored$(echo "$line" | sed "s/^</\\\033[1;31m</" | sed "s/>/>\\\033[0m/" | sed "s/\(^.*:.*$\)/\\\033[1;31m\1/" | sed "s/:/:\\\033[0m/" )"\n"
	done <<< "$1"

	echo "$colored"
}

while getopts lci: option
do
	case "${option}"
	in
		l) LAST=1;;
		c) COLOR=1;;
		i) SELECTED=${OPTARG};;
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
	elif [ -n "${SELECTED+set}" ]
	then
		ID=$SELECTED
	else	
		ID=$(( $RANDOM % $lastquote))
	fi
	
	displayedquote=$(curl -s https://danstonchat.com/$ID.html \
	  | hxnormalize -x \
	  | hxselect 'div.item-content' \
	  | w3m -dump -cols 2000 -T 'text/html' )
done 

if [ "$COLOR" = "1" ] 
then
	displayedquote=$(colorAliases "$displayedquote")
fi

echo -e "$displayedquote"

exit 0
