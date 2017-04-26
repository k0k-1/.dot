#/bin/sh

mv ../.dot ~/.dot
cd ~
mkdir -p .vim

ln -s .vimrc ~/.vimrc
ln -s .vim/rc ~/.vim/rc
ln -s .gitconfig ~/.gitconfig
ln -s .zshenv ~/.zshenv
ln -s .zsh ~/.zsh
