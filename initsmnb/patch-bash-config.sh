#!/bin/bash

cat << EOF >> ~/.bash_profile

# Workaround: when starting tmux from conda env, deactivate in all tmux sessions.
if [[ ! -z "\$TMUX" ]]; then
    for i in \$(seq \$CONDA_SHLVL); do
        conda deactivate
    done
fi
EOF


# PS1 must preceed conda bash.hook, to correctly display CONDA_PROMPT_MODIFIER
cp ~/.bashrc{,.ori}
cat << EOF > ~/.bashrc
git_branch() {
   local branch=\$(/usr/bin/git branch 2>/dev/null | grep '^*' | colrm 1 2)
   [[ "\$branch" == "" ]] && echo "" || echo "(\$branch) "
}

# All colors are bold
COLOR_GREEN="\[\033[1;32m\]"
COLOR_PURPLE="\[\033[1;35m\]"
COLOR_YELLOW="\[\033[1;33m\]"
COLOR_OFF="\[\033[0m\]"

# Define PS1 before conda bash.hook, to correctly display CONDA_PROMPT_MODIFIER
export PS1="[\$COLOR_GREEN\w\$COLOR_OFF] \$COLOR_PURPLE\\\$(git_branch)\$COLOR_OFF\\\$ "

EOF


# Original .bashrc content
cat ~/.bashrc.ori >> ~/.bashrc

# Custom aliases
cat << EOF >> ~/.bashrc

alias ll='ls -alF --color=auto'
EOF

# Better dir color on dark terminal: changed from dark blue to lighter blue
export LS_COLORS=$LS_COLORS'di=38;5;39':

#echo "On a new SageMaker terminal, which uses 'sh' by default, type 'bash -l' (without the quotes)"
