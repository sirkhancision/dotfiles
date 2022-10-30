#!/bin/bash

set -e

if [[ $(clipman show-history) != "Nothing to show" ]]; then
	clipman clear --all
	dunstify 'Área de transferência' 'O conteúdo foi apagado' -i accessories-notes
else
	dunstify 'Área de transferência' 'Não há conteúdo a ser apagado' -i accessories-notes
fi

exit 0
