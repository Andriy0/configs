# Variables
set -x PATH "$PATH:~/.local/bin:/usr/local/go/bin"
set -x QT_QPA_PLATFORMTHEME "qt5ct"
set -x QT_STYLE_OVERRIDE "kvantum"
set -x SAL_USE_VCLPLUGIN "gtk3"

# If running from tty1, exec startx
if [ (tty) = "/dev/tty1" ]
    exec startx
end
