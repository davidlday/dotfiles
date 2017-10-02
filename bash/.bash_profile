# If not running interactively, don't do anything

[ -z "$PS1" ] && return

#umask 022

# set PATH so it includes user's private bin if it exists
#if [ -d "$HOME/bin" ] ; then
#    PATH="$HOME/bin:$PATH"
#fi

# # Java
# if is-macos; then
#   export JAVA_HOME=$(/usr/libexec/java_home)
# else
#   export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))
# fi

# # Groovy
# export GROOVY_HOME=/usr/local/opt/groovy/libexec

# # Python
# export PYTHON_HOME="$(dirname $(greadlink -f $(which python3)))"
#
# # Virtualenvwrapper
# # Which python to use
# export VIRTUALENVWRAPPER_PYTHON="$(greadlink -f $(which python2))"
# # set where virutal environments will live
# export WORKON_HOME=$HOME/.virtualenvs
# # ensure all new environments are isolated from the site-packages directory
# export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'
# # use the same directory for virtualenvs as virtualenvwrapper
# export PIP_VIRTUALENV_BASE=$WORKON_HOME
# # makes pip detect an active virtualenv and install to it
# export PIP_RESPECT_VIRTUALENV=true
# # pip should only run if there is a virtualenv currently activated
# export PIP_REQUIRE_VIRTUALENV=true
# if [[ -r /usr/local/bin/virtualenvwrapper.sh ]]; then
#     source /usr/local/bin/virtualenvwrapper.sh
# else
#     echo "WARNING: Can't find virtualenvwrapper.sh"
# fi
# # Don't use site-wide packages
# export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'
# # Default project directory
# export PROJECT_HOME=$HOME/Projects

# # RVM
# export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
#
# Git Prompt
#if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
#    __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share
#    source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
#fi
