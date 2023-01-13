# Aliases
source $HOME/.bash_aliases

# Use VIM for editing
export VISUAL=vim
export EDITOR=vim

# Add Doom Emacs binaries to PATH
export PATH="$HOME/.emacs.d/bin:$PATH"

#function conda-shell {
#    nix-shell ~/.conda-shell.nix
#}

eval "$(direnv hook bash)"
