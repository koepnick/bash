#!/bin/bash
if [ -e ../.bash_aliases ]; then
	mv ../.bash_aliases ../.bash_aliases.bak
fi
if [ -L ../.bash_aliases ]; then
	rm ../.bash_aliases
fi
ln -s ./.bash/bash_aliases ../.bash_aliases
