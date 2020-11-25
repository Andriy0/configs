# Variables
set -x PATH "$PATH:~/.local/bin:/usr/local/go/bin"

# If running from tty1, exec startx
if [ (tty) = "/dev/tty1" ]
    exec startx
end
