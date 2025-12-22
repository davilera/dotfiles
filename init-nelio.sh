#!/usr/bin/env bash

mkdir -p ~/Programs/dev/sites >/dev/null 2>&1
mkdir -p ~/Programs/dev/wordpress.org >/dev/null 2>&1

function clone_repo {
  repo="$1"
  [[ -d "$repo" ]] && gum format "✅ **${repo}** is now ready!" && return
  gum spin --show-error --title="Cloning ${repo}…" -- \
    git -c http.extraHeader="Authorization: Basic $(
      printf '%s' 'davilera:'"$(pass github/personal | head -n1)" | base64 -w0
    )" clone "https://github.com/Nelio-Software/${repo}.git"
  push "$repo" >/dev/null 2>&1 || exit
  [[ -e composer.json ]] && gum spin --title="Installing PHP dependencies…" --show-error -- composer install
  [[ -e package.json ]] && gum spin --title="Installing JavaScript dependencies…" --show-error -- yarn install
  popd >/dev/null 2>&1 || exit
  [[ "$repo" != "nelio-ab-testing" ]] && [[ -d "${repo}/premium" ]] && ln -s "${repo}/premium" "${repo}-premium"
  [[ -d "$repo" ]] && gum format "✅ **${repo}** is now ready!"
}

echo "SCRIPTS"
pushd ~/.local/share >/dev/null 2>&1 || exit
clone_repo nelio-scripts
pushd nelio-scripts >/dev/null 2>&1 || exit
./install.sh
popd >/dev/null 2>&1 || exit
popd >/dev/null 2>&1 || exit

pushd ~/Programs/dev/sites >/dev/null 2>&1 || exit
[[ ! -d nelio ]] && ~/.local/bin/mkwp nelio Nelio
popd >/dev/null 2>&1 || exit

echo "PLUGINS"
if [ -d ~/Programs/dev/sites/nelio/wp-content/plugins ]; then
  pushd ~/Programs/dev/sites/nelio/wp-content/plugins >/dev/null 2>&1 || exit
  clone_repo nelio-ab-testing
  clone_repo nelio-addons
  clone_repo nelio-compare-images
  clone_repo nelio-content
  clone_repo nelio-featured-posts
  clone_repo nelio-forms
  clone_repo nelio-maps
  clone_repo nelio-page-assets
  clone_repo nelio-popups
  clone_repo nelio-related-posts
  clone_repo nelio-session-recordings
  popd >/dev/null 2>&1 || exit
fi

echo "THEMES"
if [ -d ~/Programs/dev/sites/nelio/wp-content/themes ]; then
  pushd ~/Programs/dev/sites/nelio/wp-content/themes >/dev/null 2>&1 || exit
  clone_repo nelio-web
  popd >/dev/null 2>&1 || exit
fi
