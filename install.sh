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
  echo "[*] Creating backups.."
  echo "[backup] .bashrc.bak"
  cp "$HOME/.bashrc" "$HOME/.bashrc.bak"
  echo "[backup] .tmux.conf.bak"
  cp "$HOME/.tmux.conf" "$HOME/.tmux.conf.bak"
  echo "[backup] .vimrc.bak"
  cp "$HOME/.vimrc" "$HOME/.vimrc.bak"

  echo "[*] Moving config to .config"
  mv "$PWD/../config" "$HOME/.config"

  echo "[*] Creating Symlinks.."
  # bashrc
  echo "[symlink] .bashrc -> .config/bashrc"
  ln -sf "$HOME/.config/bashrc" "$HOME/.bashrc"
  # tmux.conf
  echo "[symlink] .tmux.conf -> .config/tmux.conf"
  ln -sf "$HOME/.config/tmux.conf" "$HOME/.tmux.conf"
  # vimrc
  echo "[symlink] .vimrc -> .config/vimrc"
  ln -sf "$HOME/.config/vimrc" "$HOME/.vimrc"
}

# execution starts here
check_dir
simple
echo "[*] Simple configuration complete!"
exit
