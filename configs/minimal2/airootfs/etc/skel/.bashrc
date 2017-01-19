# Add vim as default editor
export EDITOR=vi
export PS1="[\u@\H]:\@ >\[$(tput sgr0)\]"

# Enable color output in console
alias ls='ls --color=auto'
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias install-archstrike='archstrike-installer'

# Display instructions
cat /root/install.txt
