#!/bin/sh

# check if ~/.config already exists, if it does, print error and exit.
check_dir(){
  if test -d "$HOME/.config"; then
    echo "[!][error] A directory named .config already exists in the home directory! Exiting without changes."
    exit
  elif test -f "$HOME/.config"; then
    echo "[!][error] There is already a file named .config in the home directory! Exiting without changes."
    exit
  fi
}

# makes backups and creates symlinks for .bashrc .vimrc and .tmux.conf in hidden .config folder
simple() {
  echo "[*] Moving config to .config"
  mv "$PWD/../config" "$HOME/.config"

  # bashrc
  cp "$HOME/.bashrc" "$HOME/.bashrc.bak"
  echo "[*][backup] Created .bashrc.bak"
  ln -sf "$HOME/.config/bashrc" "$HOME/.bashrc"
  
  # tmux.conf
  cp "$HOME/.tmux.conf" "$HOME/.tmux.conf.bak"
  echo "[*][backup] Created .tmux.conf.bak"
  ln -sf "$HOME/.config/tmux.conf" "$HOME/.tmux.conf"
  
  # vimrc
  cp "$HOME/.vimrc" "$HOME/.vimrc.bak"
  echo "[*][backup] Created .vimrc.bak"
  ln -sf "$HOME/.config/vimrc" "$HOME/.vimrc"
}

# execution starts here
check_dir
simple
echo "[*] Simple config complete!"
exit
