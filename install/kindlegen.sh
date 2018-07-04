#!/usr/bin/env bash
# Not strictly necessary, but left over from old readlink/greadlink.
REALPATH=$(command -v realpath)

# Find current script source, if possible
CURRENT_SCRIPT="${BASH_SOURCE[0]}"

# Resolve DOTFILES_DIR (assuming ~/.dotfiles on distros without realpath and/or $BASH_SOURCE/$0)
if [[ -n "$CURRENT_SCRIPT" && -x "$REALPATH" ]]; then
  SCRIPT_PATH=$($REALPATH "$CURRENT_SCRIPT")
  DOTFILES_DIR=$(dirname "$(dirname "$SCRIPT_PATH")")
elif [ -d "$HOME/.dotfiles" ]; then
  DOTFILES_DIR="$HOME/.dotfiles"
else
  echo "Unable to find dotfiles, exiting."
  return
fi

# Source functions, assuming they're not already
# shellcheck source=/dev/null
source "$DOTFILES_DIR/shell/.function"

# TODO: Figure out how to do upgrades.
# Installs in user space ($HOME/.local)
if ! is-executable kindlegen; then
  TMPDIR=$(mktemp -d /tmp/kindlegen-XXXXXXXX)
  mkdir -p "$HOME/.local/opt/KindleGen" "$HOME/.local/bin"
  if is-macos; then
    KGEN_LINK="http://kindlegen.s3.amazonaws.com/KindleGen_Mac_i386_v2_9.zip"
    wget --show-progres --progress=bar -q "$KGEN_LINK" -O "$TMPDIR/kindlegen_macosx.zip"
    unzip "$TMPDIR/kindlegen_macosx.zip" -d "$HOME/.local/opt/KindleGen"
  else
    KGEN_LINK="http://kindlegen.s3.amazonaws.com/kindlegen_linux_2.6_i386_v2_9.tar.gz"
    wget --show-progres --progress=bar -q "$KGEN_LINK" -O "$TMPDIR/kindlegen_linux.tar.gz"
    tar --extract --verbose --gzip --file="$TMPDIR/kindlegen_linux.tar.gz" --directory="$HOME/.local/opt/KindleGen"
  fi
  ln -svf "$HOME/.local/opt/KindleGen/kindlegen" "$HOME/.local/bin/kindlegen"
  rm -rf "$TMPDIR"
else
  echo "KindleGen already installed at $(command -v kindlegen)."
fi
