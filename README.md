# dotfiles

The repository root is the [chezmoi][] source directory: everything here except
the entries listed in `.chezmoiignore` is deployed to `~`. `ansible/` installs
packages, applies macOS defaults, and bootstraps plugins.

## Setup

```sh
cd ansible && ./apply.sh
```

The first run prompts for the git identity (name / email / signing key) and
stores it in `~/.config/chezmoi/chezmoi.toml`, so a work machine and a personal
machine can share this repo.

## Editing

Filenames follow chezmoi's [source state naming][naming] — `dot_` for a leading
dot, `private_` for `0700`, `executable_` for `+x`, `.tmpl` for templated files.

```sh
chezmoi edit ~/.gitconfig   # opens dot_gitconfig.tmpl
chezmoi diff                # preview
chezmoi apply               # deploy
```

Anything added to the repository root that is *not* meant for `~` — build
scripts, docs, tooling — must be added to `.chezmoiignore`.

[chezmoi]: https://www.chezmoi.io/
[naming]: https://www.chezmoi.io/reference/source-state-attributes/

## References

- [benbrastmckie/.config](https://github.com/benbrastmckie/.config)
- [craftzdog/dotfiles-public](https://github.com/craftzdog/dotfiles-public)
- [kaz/dotfiles](https://github.com/kaz/dotfiles)
