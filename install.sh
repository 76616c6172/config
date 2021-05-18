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
  echo "[backing up] ~/.zshrc.bak"
  cp "$HOME/.zshrc" "$HOME/.zshrc.bak"
  echo "[backing up] ~/.bashrc.bak"
  cp "$HOME/.bashrc" "$HOME/.bashrc.bak"
  echo "[backing up] ~/.tmux.conf.bak"
  cp "$HOME/.tmux.conf" "$HOME/.tmux.conf.bak"
  echo "[backing up] ~/.vimrc.bak"
  cp "$HOME/.vimrc" "$HOME/.vimrc.bak"
  echo "[backing up] ~/.vimrc.bak"
  cp "$HOME/.vimrc" "$HOME/.vimrc.bak"

  echo "[*] Moving backups into config/backups.."
  mkdir "$PWD/backup"
  for f in .zshrc .bashrc .vimrc .tmux.conf; do
    mv "$HOME/$f" "$PWD/config/backup"
  done


  echo "[*] Moving config to .configuration"
  mv "$PWD/../config" "$HOME/.configuration"

  echo "[*] Creating Symlinks.."
  # zshrc
  echo "[symlinked] .zshrc -> .configuration/zshrc"
  ln -sf "$HOME/.configuration/zshrc" "$HOME/.zshrc"
  # bashrc
  echo "[symlinked] .bashrc -> .configuration/bashrc"
  ln -sf "$HOME/.configuration/bashrc" "$HOME/.bashrc"
  # tmux.conf
  echo "[symlinked] .tmux.conf -> .configuration/tmux.conf"
  ln -sf "$HOME/.configuration/tmux.conf" "$HOME/.tmux.conf"
  # vimrc
  echo "[symlinked] .vimrc -> .configuration/vimrc"
  ln -sf "$HOME/.configuration/vimrc" "$HOME/.vimrc"
}

# execution starts here
check_dir
simple
echo "[*] Simple configuration complete!"
exit
