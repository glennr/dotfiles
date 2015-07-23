



glennr dotfiles
===================

Requirements
------------

Both [Thoughtbot dotfile](https://github.com/thoughtbot/dotfiles) and its'
dependent [RCM](https://github.com/thoughtbot/rcm)

Install
-------

Clone onto your laptop in a golang-like src hierarchy

    mkdir ~/src
    mkdir ~/src/glennr
    cd src/glennr/
    git clone git://github.com/glennr/dotfiles.git

To make sure rcm picks up these local customizations, you need to create a
symlink from ~/dotfiles-local to this repo dir i.e.

    ln -s ~/src/thoughtbot/dotfiles dotfiles

And rerun rcup

   env RCRC=$HOME/dotfiles/rcrc rcup

