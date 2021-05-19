#!/bin/sh

# check if ~/.config already exists, if it does, print error and exit.
check_dir(){
  if test -d "$HOME/.configuration"; then
    echo "[!][error] A directory named .configuration already exists in the home directory! Exiting without changes."
    exit
  elif test -f "$HOME/.configuration"; then
    echo "[!][error] There is already a file named .configuration in the home directory! Exiting without changes."
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

  # Moving backups to keep everything tidy
  echo "[*] Moving backups into config/backup"
  mkdir "$PWD/backup"
  for f in .zshrc .bashrc .vimrc .tmux.conf; do
    mv "$HOME/$f.bak" "$PWD/backup"
  done

  # Hiding the config folder
  echo "[*] Moving config to .configuration"
  mv "$PWD/../config" "$HOME/.configuration"

  # Symlinking to apply the new config files
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
