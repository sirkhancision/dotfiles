#!/usr/bin/env nu

def main [shot_type: string] {
  let images_dir = (^xdg-user-dir PICTURES)
  let image_name = $"(date now | date format "%Y-%m-%d_%H-%M-%S").png"
  let screenshots_dir = $"($images_dir)/Screenshots"
  let image_path = $"($screenshots_dir)/($image_name)"

  if ($shot_type not-in ["screen", "active", "area"]) {
    error make {msg: "The type of screenshot has to be either screen, active or area"}
  }

  mkdir $screenshots_dir
  screenshot $image_path $shot_type
  notify $image_name $image_path
}

def screenshot [
  image_path: string
  type: string
  ] {
  ^grimshot save $type $image_path
  if ($image_path | path exists) {
    ^paplay ~/.config/sway/audio/screen-capture.ogg
    open $image_path | ^wl-copy --type image/png
  }
}

def notify [
  image_name: string
  image_path: string
  ] {
  let notification_text = $"<i>($image_name)</i>
Copiado para a área de transferência"

  ^dunstify "Captura de tela" $notification_text -I $image_path
}
