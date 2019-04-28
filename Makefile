
setup-nvim:
	if [ ! -d "~/.config/nvim" ]; then mkdir ~/.config/nvim; fi
	ln -s nvim.init.vim ~/.config/nvim/init.vim 
