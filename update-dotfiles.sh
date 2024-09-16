#!/bin/sh

# Change this to the directory where your dotfiles are stored
DOTFILES_DIR=~/dotfiles

# Change to the dotfiles directory
cd "$DOTFILES_DIR" || exit

# Iterate over each folder and run stow on it
for folder in */ ; do
  # Run stow on the folder (removing the trailing slash from folder name)
  stow "${folder%/}"
done