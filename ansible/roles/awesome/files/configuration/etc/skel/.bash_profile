
[[ -f ~/.bashrc ]] && . ~/.bashrc

export PATH=$PATH:$HOME/.local/bin:$HOME/bin

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

