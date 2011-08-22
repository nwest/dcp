#!/bin/sh

# Freak out and quit if we don't have Git and/or cURL.
hash git 2>&- || { echo >&2 "We need Git first, cap'n!"; exit 1; }
hash wget 2>&- && DCP_GET="wget --no-check-certificate --content-disposition -qO -"
hash curl 2>&- && DCP_GET="curl -skLJ"
test "$DCP_GET" || { echo >&2 "Error! Couldn't find cURL or Wget!"; exit 1; }

# Save the whales! I mean working directory!
OLD_WD=`pwd`
cd "$HOME"

# Clone oh-my-zsh regardless, not a single fuck is given this day.
test -d ".oh-my-zsh" || git clone "git://github.com/robbyrussell/oh-my-zsh.git" ".oh-my-zsh"

# If it's me, I want to be able to change my dotfiles,
# otherwise clone the public repos.
GIT_PREFIX="git://github.com/dpoggi"
test "$ITS_ME" && GIT_PREFIX="git@github.com:dpoggi"

# Dotfiles and Vim config
test -d ".dcp" || git clone "$GIT_PREFIX/dcp.git" ".dcp"
test -d ".vim" || git clone "$GIT_PREFIX/dotvim.git" ".vim"

# Install RVM, NVM, and pythonbrew:
sh "$HOME/.dcp/bin/install_rvm.sh"
rm -f "$HOME/.rvmrc"
test -d ".nvm" || git clone "$GIT_PREFIX/nvm.git" ".nvm"
test -d ".pythonbrew" || ($DCP_GET "http://xrl.us/pythonbrewinstall" | bash)

# Get Vim rockin'
cd "$HOME/.vim"
git submodule update --init
git submodule foreach git pull origin master
cd "$HOME"

# Install the symlinks
sh "$HOME/.dcp/bin/install_dcp.sh"

# Get back to where we were
cd "$OLD_WD"

# Report.
echo
echo "Bro-tips: restart your shell, don't forget to compile Command-T."