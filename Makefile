
setup-nvim:
	if [ ! -d "~/.config/nvim" ]; then mkdir ~/.config/nvim; fi
	ln -s ~/src/glennr/dotfiles/nvim.init.vim ~/.config/nvim/init.vim
	apt-get install fzy

