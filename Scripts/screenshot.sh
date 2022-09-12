pic_dir=$(xdg-user-dir PICTURES)

grim $pic_dir/Screenshots/scrn-$(date +"%d-%m-%Y-%H-%M-%S").png
image_path=$(echo -n "$pic_dir/Screenshots/" && ls -Art $pic_dir/Screenshots/ | tail -n 1)
wl-copy < $image_path
