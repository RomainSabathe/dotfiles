# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

if xrandr --query | grep "^DP1 connected";
then
  sed -i '/Xft.dpi/c\Xft.dpi: 96' $HOME/.Xresources
  sed -i '/dpi = /c\dpi = 96' $HOME/.config/polybar/config
  sed -i '/height = /c\height = 27' $HOME/.config/polybar/config
  xrandr --output DP1 --pos 1920x0 --primary
  xrandr --output eDP1 --mode 1920x1080
else
  sed -i '/Xft.dpi/c\Xft.dpi: 196' $HOME/.Xresources
  sed -i '/dpi = /c\dpi = 196' $HOME/.config/polybar/config
  sed -i '/height = /c\height = 54' $HOME/.config/polybar/config
fi


# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi
# set PATH so it includes user's private bin directories
PATH="$HOME/bin:$HOME/.local/bin:$PATH"
