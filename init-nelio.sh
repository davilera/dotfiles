#!/usr/bin/env bash

title() {
  echo ""
  gum style --bold --trim --foreground=2 "$1"
}

clone_git() {
  repo="$1"
  if [[ ! -d "$repo" ]]; then
    gum spin --show-error --title="Cloning ${repo}…" -- \
      git -c http.extraHeader="Authorization: Basic $(
        printf '%s' 'davilera:'"$(pass github/personal | head -n1)" | base64 -w0
      )" clone "https://github.com/Nelio-Software/${repo}.git"
  fi
  pushd "$repo" >/dev/null 2>&1 || exit
  [[ -e composer.json ]] && gum spin --title="Installing PHP dependencies…" --show-error -- composer install
  [[ -e package.json ]] && gum spin --title="Installing JavaScript dependencies…" --show-error -- yarn install
  [[ -e package.json ]] && [[ "$(jq -e '.scripts? | has("build")' package.json)" == "true" ]] && gum spin --title="Building ${repo}…" --show-error -- yarn run build
  popd >/dev/null 2>&1 || exit
  [[ "$repo" != "nelio-ab-testing" ]] && [[ -d "${repo}/premium" ]] && [[ ! -e "${repo}-premium" ]] && ln -s "${repo}/premium" "${repo}-premium"
  [[ -d "$repo" ]] && gum format "✅ **${repo}** is now ready!"
}

# --------------------------------------------------------
title "GIT SCRIPTS"
# --------------------------------------------------------

pushd ~/.local/share >/dev/null 2>&1 || exit
clone_git nelio-scripts
pushd nelio-scripts >/dev/null 2>&1 || exit
./install.sh
popd >/dev/null 2>&1 || exit
popd >/dev/null 2>&1 || exit

mkdir -p ~/Programs/dev/sites >/dev/null 2>&1
pushd ~/Programs/dev/sites >/dev/null 2>&1 || exit
[[ ! -d nelio ]] && ~/.local/bin/mkwp nelio Nelio
popd >/dev/null 2>&1 || exit

# --------------------------------------------------------
title "GIT PLUGINS"
# --------------------------------------------------------

if [ -d ~/Programs/dev/sites/nelio/wp-content/plugins ]; then
  pushd ~/Programs/dev/sites/nelio/wp-content/plugins >/dev/null 2>&1 || exit
  clone_git nelio-ab-testing
  clone_git nelio-addons
  clone_git nelio-compare-images
  clone_git nelio-content
  clone_git nelio-featured-posts
  clone_git nelio-forms
  clone_git nelio-maps
  clone_git nelio-page-assets
  clone_git nelio-popups
  clone_git nelio-related-posts
  clone_git nelio-session-recordings
  popd >/dev/null 2>&1 || exit
fi

# --------------------------------------------------------
title "GIT THEMES"
# --------------------------------------------------------

if [ -d ~/Programs/dev/sites/nelio/wp-content/themes ]; then
  pushd ~/Programs/dev/sites/nelio/wp-content/themes >/dev/null 2>&1 || exit
  clone_git nelio-web
  popd >/dev/null 2>&1 || exit
fi

# --------------------------------------------------------
title "SVN PLUGINS"
# --------------------------------------------------------

mkdir -p ~/Programs/dev/wordpress.org >/dev/null 2>&1

clone_svn() {
  repo="$1"
  if [[ ! -d "$repo" ]]; then
    gum spin --show-error --title="Cloning ${repo}…" -- \
      svn checkout "https://davilera@plugins.svn.wordpress.org/${repo}/"
  fi
  [[ -d "$repo" ]] && gum format "✅ **${repo}** is now ready!"
}

if [ -d ~/Programs/dev/wordpress.org ]; then
  pushd ~/Programs/dev/wordpress.org >/dev/null 2>&1 || exit
  clone_svn nelio-ab-testing
  clone_svn nelio-compare-images
  clone_svn nelio-content
  clone_svn nelio-featured-posts
  clone_svn nelio-forms
  clone_svn nelio-maps
  clone_svn nelio-popups
  clone_svn nelio-related-posts
  clone_svn nelio-session-recordings
  popd >/dev/null 2>&1 || exit
fi
