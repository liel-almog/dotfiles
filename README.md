# dotfiles

This repo contains my dotfile configuration, allowing for a consistent computing experience across multiple machines.

## Inspiration

Inspired by Elliott Minns [dotfiles](https://github.com/elliottminns/dotfiles?tab=readme-ov-file).

## Update script

Stow works such that it creates a symlink to one level before.
For example if we run the command `stow git` on `~/dotfiles` it will do `cd ..` and then create a symlink.

This is why we **iterate** over all of the folders and run `stow` from the root level.
