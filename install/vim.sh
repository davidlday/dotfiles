#!/usr/bin/env bash
source ../shell/.function

if ! is-executable vim; then
  echo "Skipped: vim. Apparently vim isn't installed."
  return
else
  # Desert Theme: https://vim.sourceforge.io/scripts/script.php?script_id=105
  if [ ! -f ~/.vim/colors/desert.vim ]; then
    echo "Installing Desert Theme"
    mkdir -p ~/.vim/colors
    curl -LSso ~/.vim/colors/desert.vim https://raw.githubusercontent.com/fugalh/desert.vim/master/colors/desert.vim
  fi
  echo "Desert Theme Installed"

  # Pathogen: https://github.com/tpope/vim-pathogen
  if [ ! -f ~/.vim/autoload/pathogen.vim ]; then
    echo "Installing Pathogen"
    mkdir -p ~/.vim/autoload ~/.vim/bundle
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
  fi
  echo "Pathogen installed"

  # EditorConfig: https://github.com/editorconfig/editorconfig-vim#readme
  if [ ! -d ~/.vim/bundle/editorconfig-vim ]; then
    echo "Installing EditorConfig-Vim"
    cd ~/.vim/bundle
    git clone https://github.com/editorconfig/editorconfig-vim.git
    cd -
  fi
  echo "EditorConfig-Vim installed"
fi
