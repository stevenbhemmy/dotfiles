My Dotfiles

Managed with GNU stow
```
sudo apt install stow
```

To install dotfiles
```
git clone git@github.com:stevenbhemmy/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
stow -v .
```

To make stow ignore files edit `.stow-local-ignore`.
