swaymsg -t get_tree | \
    jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | \
    slurp | grim -g - $HOME/Imagens/Screenshots/scrn-$(date +"%d-%m-%Y-%H-%M-%S").png
image_path=$(echo -n "$HOME/Imagens/Screenshots/" ; ls -Art $HOME/Imagens/Screenshots/ | tail -n 1)
wl-copy < $image_path
