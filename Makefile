.PHONY: install

all: install

install:
	cp .bashrc ~/ && chmod 600 ~/.bashrc
	cp .vimrc ~/ && chmod 600 ~/.vimrc

