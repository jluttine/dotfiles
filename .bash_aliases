
# Listing
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -a'
alias lla='ls -lha'
alias df='df -h'
#alias du='du -hs'

alias rm='rm -I'

#alias emacs='emacs -nw'

alias install='sudo aptitude install'
alias search='aptitude search'
alias show='aptitude show'
alias remove='sudo aptitude remove'

# Interactive
alias cp='cp -i'
alias mv='mv -i'

# Zipping and stuff
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

# Directory navigation
alias home='cd ~'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias here='nautilus `pwd`'

# Pacman aliases
alias pac-upg='sudo pacman -Syu'		# Synchronize with repositories and then upgrade packages that are out of date on the local system.
alias pac-ins='sudo pacman -S'		# Install specific package(s) from the repositories
alias pac-insfile='sudo pacman -U'		# Install specific package not from the repositories but from a file 
alias pac-unins='sudo pacman -R'		# Remove the specified package(s), retaining its configuration(s) and required dependencies
alias pac-rem='sudo pacman -Rns'		# Remove the specified package(s), its configuration(s) and unneeded dependencies
alias pac-info='pacman -Si'		# Display information about a given package in the repositories
alias pac-search='pacman -Ss'		# Search for package(s) in the repositories
alias pac-info-loc='pacman -Qi'		# Display information about a given package in the local database
alias pac-search-loc='pacman -Qs'		# Search for package(s) in the local database
alias pac-ls-orph="pacman -Qdt"		# List all packages which are orphaned
alias pac-clean="sudo pacman -Scc"		# Clean cache - delete all not currently installed package files
alias pac-pkgfiles="pacman -Ql"		# List all files installed by a given package
alias pac-expl="pacman -D --asexp"	# Mark one or more installed packages as explicitly installed 
alias pac-impl="pacman -D --asdep"	# Mark one or more installed packages as non explicitly installed

# '[r]emove [o]rphans' - recursively remove ALL orphaned packages
alias pac-rem-orph="pacman -Qtdq > /dev/null && sudo pacman -Rns \$(pacman -Qtdq | sed -e ':a;N;$!ba;s/\n/ /g')"

# Additional pacman alias examples
alias pac-upd='sudo pacman -Sy && sudo abs'         # Update and refresh the local package and ABS databases against repositories
alias pac-insdep='sudo pacman -S --asdeps'            # Install given package(s) as dependencies
alias pac-mir='sudo pacman -Syy'                    # Force refresh of all package lists after updating /etc/pacman.d/mirrorlist

alias yadm-nixos='yadm --yadm-dir /etc/nixos/.yadm/config --yadm-data /etc/nixos/.yadm/data'
