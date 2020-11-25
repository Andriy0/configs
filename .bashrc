# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# Variables
export PATH="$PATH:/usr/local/go/bin:$HOME/.local/bin"

# If running from tty1, do startx
if [ "$(tty)" = "/dev/tty1" ]; then
    exec startx
fi

# Start fish shell
fish
