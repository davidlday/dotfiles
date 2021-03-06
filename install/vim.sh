#!/usr/bin/env bash
source ../shell/.function

if ! is-executable vim; then
  echo "Apparently vim isn't installed. Installing."
  if ! can-brew; then
    source ./brew.sh
  fi
  brew install vim
fi

# Desert Theme: https://vim.sourceforge.io/scripts/script.php?script_id=105
if [ ! -f "$HOME/.vim/colors/desert.vim" ]; then
  echo "Installing Desert Theme"
  mkdir -p "$HOME/.vim/colors"
  curl -LSso "$HOME/.vim/colors/desert.vim" https://raw.githubusercontent.com/fugalh/desert.vim/master/colors/desert.vim
fi
echo "Desert Theme Installed"

# Pathogen: https://github.com/tpope/vim-pathogen
if [ ! -f "$HOME/.vim/autoload/pathogen.vim" ]; then
  echo "Installing Pathogen"
  mkdir -p "$HOME/.vim/autoload" "$HOME/.vim/bundle"
  curl -LSso "$HOME/.vim/autoload/pathogen.vim" https://tpo.pe/pathogen.vim
fi
echo "Pathogen installed"

# EditorConfig: https://github.com/editorconfig/editorconfig-vim#readme
if [ ! -d "$HOME/.vim/bundle/editorconfig-vim" ]; then
  echo "Installing EditorConfig-Vim"
  (
    cd "$HOME/.vim/bundle" || exit
    git clone https://github.com/editorconfig/editorconfig-vim.git
  )
fi
echo "EditorConfig-Vim installed"

# Direnv: https://github.com/direnv/direnv.vim#install
if [ ! -d "$HOME/.vim/bundle/direnv.vim" ]; then
  echo "Installing Direnv-Vim"
  (
    cd "$HOME/.vim/bundle" || exit
    git clone https://github.com/direnv/direnv.vim.git
  )
fi
echo "Direnv-Vim installed"
