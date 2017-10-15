# If not running interactively, don't do anything

[ -z "$PS1" ] && return

# Find greadlink/readlink
# Original: READLINK=$(which greadlink || which readlink)
READLINK=""
if [ type --all greadlink >/dev/null 2>&1 ]; then
  READLINK=$(which greadlink)
elif [ type --all readlink >/dev/null 2>&1 ]; then
  READLINK=$(which readlink)
else
  unset READLINK
fi

# Find current script source, if possible

CURRENT_SCRIPT=$BASH_SOURCE

# Resolve DOTFILES_DIR (assuming ~/.dotfiles on distros without readlink and/or $BASH_SOURCE/$0)

if [[ -n $CURRENT_SCRIPT && -x "$READLINK" ]]; then
  SCRIPT_PATH=$($READLINK -f "$CURRENT_SCRIPT")
  DOTFILES_DIR=$(dirname "$(dirname "$SCRIPT_PATH")")
elif [ -d "$HOME/.dotfiles" ]; then
  DOTFILES_DIR="$HOME/.dotfiles"
else
  echo "Unable to find dotfiles, exiting."
  return
fi

# Read cache

DOTFILES_CACHE="$DOTFILES_DIR/.cache.sh"
[ -f "$DOTFILES_CACHE" ] && . "$DOTFILES_CACHE"

# Finally we can source the dotfiles (order matters)

for DOTFILE in "$DOTFILES_DIR"/shell/.{function,function_*,path,env,alias,completion,grep,prompt,.exports_*,custom}; do
  [ -f "$DOTFILE" ] && . "$DOTFILE"
done

if is-macos; then
  for DOTFILE in "$DOTFILES_DIR"/shell/.{env,alias,function}.macos; do
    [ -f "$DOTFILE" ] && . "$DOTFILE"
  done
fi

# Set LSCOLORS
# TODO: Need to make dircolors work on MacOS via gdircolors.
if is-macos; then
  eval "$(gdircolors "$DOTFILES_DIR"/shell/.dircolors)"
else
  eval "$(dircolors "$DOTFILES_DIR"/shell/.dircolors)"
fi

# Hook for extra/custom stuff

DOTFILES_EXTRA_DIR="$HOME/.extra"

if [ -d "$DOTFILES_EXTRA_DIR" ]; then
  for EXTRAFILE in "$DOTFILES_EXTRA_DIR"/runcom/*.sh; do
    [ -f "$EXTRAFILE" ] && . "$EXTRAFILE"
  done
fi

# Clean up

unset READLINK CURRENT_SCRIPT SCRIPT_PATH DOTFILE EXTRAFILE

# Export

export DOTFILES_DIR DOTFILES_EXTRA_DIR
