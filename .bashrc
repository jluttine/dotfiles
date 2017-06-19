
# added by Miniconda3 3.19.0 installer
# export PATH="/home/jluttine/Workspace/miniconda3/bin:$PATH"

# added by travis gem
[ -f /home/jluttine/.travis/travis.sh ] && source /home/jluttine/.travis/travis.sh

# Aliases
source $HOME/.bash_aliases

# Use VIM for editing
export VISUAL=vim
export EDITOR=vim

function conda-shell {
    nix-shell ~/.conda-shell.nix
}

#export PATH=$PATH:/usr/local/bin:$HOME/.local/bin

# NVM
#if [ -s ~/.nvm/nvm.sh ]; then
#        NVM_DIR=~/.nvm
#        source ~/.nvm/nvm.sh
#fi

# Virtualenvwrapper
#export WORKON_HOME=~/.virtualenvs
#source /usr/bin/virtualenvwrapper.sh

# GPG agent settings
#export GPG_TTY=$(tty)
