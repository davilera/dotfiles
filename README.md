# My Omarchy-Based Dotfiles

Welcome! This is my personal dotfiles, meant to live _on top of_ an [**Omarchy**
installation](https://github.com/basecamp/omarchy).

This repo captures my personal preferences, developer tooling, and integrations,
especially tuned for WordPress plugin development. Use it as a base, fork it, or
adapt pieces for your own workflow. 😊

---

## Structure & What Lives Here

Here’s how I’ve organized things:

| Folder            | Purpose / What you’ll find inside                                                                                         |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------- |
| `bin/`            | Handy scripts I use often (e.g. wrappers shortcuts)                                                                       |
| `composer/`       | My global Composer setup files                                                                                            |
| `dconf/`          | Exports of GNOME/GTK (or related) settings I care about                                                                   |
| `git/`            | My gitconfig, hooks, aliases, etc                                                                                         |
| `hypr/`           | Hyprland bindings, customizations, layouts                                                                                |
| `kitty/`          | Keybindings, tweaks, theme tweaks for the Kitty terminal                                                                  |
| `meld/`           | A custom `gtksourceview-4` style (using Catppuccin Mocha) for Meld                                                        |
| `nvim/`           | My LazyVim / Neovim config, including plugin choices                                                                      |
| `shell/`          | My shell setup (currently Bash): aliases, ENV tweaks, nvm logic, etc                                                      |
| `smassh/`         | My “super minimal SSH” / simpler SSH config layer (with Catppuccin theming)                                               |
| `tooling-config/` | Global configs (ESLint, prettier, stylelint, etc) so tooling _without per-project defines_ still follows WordPress style  |
| `trash/`          | A systemd “task” (timer + service) to periodically purge old items from the “trash” (for me, I alias `rm` to `trash-cli`) |
| `uwsm/`           | Config files inherited from Omarchy’s `uwsm` (user workflow / session manager) with my custom overlays                    |
| `waybar/`         | Config files inherited from Omarchy’s `waybar` with my custom overlays                                                    |

Additionally, there is an `install.sh` script at the root whose job is:

1. Install a curated list of packages I use daily
2. Configure and bootstrap certain assets (e.g. Inkscape extensions, `navi`
   cheats, etc)
3. Globally install some `npm` packages I rely on
4. Stow (or symlink) all the config folders above into the right places
5. Apply a few extra tweaks / customizations using Omarchy’s own functions

---

## How to Use / Full Installation

Here’s how I expect someone (or future me) to apply this setup:

1. **Start with a working Omarchy install**  
   This repo is not a _replacement_ for Omarchy — it’s an overlay. Make sure
   Omarchy is installed and functioning (Hyprland, `uwsm`, etc). See the [Omarchy
   GitHub page](https://github.com/basecamp/omarchy) for official docs.

2. **Clone or download this repo**

    ```bash
    git clone https://github.com/davilera/dotfiles.git ~/.dotfiles
    cd ~/.dotfiles
    ```

3. **Review `install.sh`**
   It’s polite (and safe) to read through the logic before execution.

4. **Run the installer**

    ```bash
    ./install.sh
    ```

If at any point you want to revert or remove the overlay, you can remove the
symlinks / stows, and selectively disable parts you don’t want.

---

## Packages I Install & Why (Quick Reference)

Below is a compact list of packages I typically install, with short reminder
notes for myself (and others) on why they’re there:

| Package               | Purpose / Reason                                              |
| --------------------- | ------------------------------------------------------------- |
| `aspell-ca`           | Catalan spelling support                                      |
| `aspell-es`           | Spanish spelling support                                      |
| `aws-cli-v2`          | AWS command-line tooling                                      |
| `bat`                 | Better `cat` with syntax highlighting                         |
| `btop`                | Resource monitor / system dashboard                           |
| `bun-bin`             | JavaScript runtime / faster tooling (if you use Bun)          |
| `cargo`               | Rust package manager / build tool                             |
| `composer`            | PHP dependency manager (used in WordPress plugin development) |
| `curl`                | HTTP transfers / API calls / fetch scripts                    |
| `difftastic`          | Better diffing tool (structural diffs)                        |
| `dysk`                | Better info on mounted filesystems                            |
| `filezilla`           | GUI FTP / SFTP client                                         |
| `firefox`             | Web browser (my default)                                      |
| `firefoxpwa`          | Firefox + progressive web app support / wrappers              |
| `gimp`                | Image editing / quick edits                                   |
| `go`                  | Go language tooling (sometimes useful)                        |
| `hplip`               | Printer / scanner support (HP)                                |
| `hunspell-ca`         | Catalan dictionary for Hunspell                               |
| `hunspell-es_any`     | Spanish dictionary for Hunspell (any variant)                 |
| `imagemagick`         | CLI image manipulation                                        |
| `inkscape`            | Vector design / SVG editing                                   |
| `jq`                  | JSON processing in CLI pipelines                              |
| `kitty`               | Terminal emulator (my preference)                             |
| `lsd`                 | Modern `ls` replacement with colors, icons, etc.              |
| `luarocks`            | Lua package manager                                           |
| `meld`                | GUI diff / merge tool                                         |
| `navi`                | CLI cheatsheet lookup tool                                    |
| `npm`                 | JavaScript package manager                                    |
| `nvm`                 | Node version manager                                          |
| `openssh`             | SSH client / server                                           |
| `pass`                | Password manager (Unix philosophy)                            |
| `perl-image-exiftool` | Reading/writing EXIF / metadata                               |
| `poedit`              | GUI translation / PO file editor                              |
| `prettyping`          | More readable ping output                                     |
| `python-markdown`     | CLI markdown processing                                       |
| `python-pip`          | Python package installer                                      |
| `python3`             | Python interpreter                                            |
| `ruby`                | Ruby runtime/scripts (some tools / dependencies)              |
| `smassh`              | Lightweight SSH / config wrapper (my layer)                   |
| `stow`                | For managing symlinks of dotfiles                             |
| `subversion`          | If I ever deal with SVN repos                                 |
| `tldr`                | Simplified manpages / cheat sheets                            |
| `the_silver_searcher` | Fast code search (ag clone)                                   |
| `trash-cli`           | “Safe rm” — moves files to trash instead of deleting          |
| `tree`                | Directory tree visualization                                  |
| `wget`                | CLI download utility                                          |
| `yq`                  | YAML processing in CLI                                        |
| `zoxide`              | Smart directory jumping (better cd)                           |
| `zoom`                | Video conferencing client                                     |

---

## Assumptions & Caveats

- **This repo assumes Omarchy is already installed** (i.e. it does _not_ replicate
    or replace Omarchy’s core setup)
- My tooling choices (linters, formatter rules, plugin settings) are heavily
    influenced by WordPress coding standards and plugin ecosystem norms
- If a project you work on already defines its own tooling (e.g. `.eslintrc`,
    `.phpcs.xml`), those will usually take priority over my global one (I hope
    so)
- Always back up your existing configs before running the install script
- Use this as a scaffold or reference, and feel free to remove, replace, or
    adapt parts you don’t like (duh)

---

## Acknowledgments & Thanks

Huge thanks to **DHH** for creating **Omarchy** and maintaining a slick,
opinionated dev environment.

Thanks also to all the folks in the open source world whose work I rely on.

Feel free to reuse, fork, and adapt. This repo is not meant to be a starting
point for anyone, but that’s up to you. Actually, you know what? If you build
something cool on top of it, let me know!

Happy hacking! 🧵
