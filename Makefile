.PHONY: install

all: install

install:
	cp .bashrc ~/ && chmod 600 ~/.bashrc
	cp .bash_aliases ~/ && chmod 600 ~/.bash_aliases
	cp .vimrc ~/ && chmod 600 ~/.vimrc

