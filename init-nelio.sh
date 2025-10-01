#!/usr/bin/bash

mkdir -p ~/Programs/dev/sites 2>/dev/null
mkdir -p ~/Programs/dev/wordpress.org 2>/dev/null

cd ~/Programs/dev/sites 2>/dev/null || exit
~/.local/bin/mkwp nelio Nelio
cd - 2>/dev/null || exit
if [ -d ~/Programs/dev/sites/nelio/wp-content/plugins ]; then
  pushd ~/Programs/dev/sites/nelio/wp-content/plugins 2>/dev/null || exit
  [[ ! -d nelio-ab-testing ]] && git clone https://davilera@github.com/Nelio-Software/nelio-ab-testing
  [[ ! -d nelio-addons ]] && git clone https://davilera@github.com/Nelio-Software/nelio-addons
  [[ ! -d nelio-content ]] && git clone https://davilera@github.com/Nelio-Software/nelio-content
  [[ ! -d nelio-maps ]] && git clone https://davilera@github.com/Nelio-Software/nelio-maps
  popd 2>/dev/null || exit
fi
