# dotfiles

The repository root is the [chezmoi][] source directory. Everything here except
the entries in `.chezmoiignore` is deployed to `~` as symlinks
(`mode = "symlink"`), so editing `~/.config/...` edits this repository directly.
Templates, `private_` and `executable_` files are copied instead.

## Setup

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply --exclude=externals --source ~/dotfiles flag3
```

Then set up the 1Password SSH agent and run `chezmoi apply` once more: the
repositories in `.chezmoiexternal.toml` include private ones cloned over SSH.

Supported: macOS, Debian / Ubuntu.

`.chezmoiscripts/` installs packages (Homebrew + mas on macOS, apt on Linux,
aqua and npm on both), sets up fish / fisher / tide, and applies macOS
defaults. `run_onchange_` scripts re-run when
their content (or the hashed file, e.g. `Brewfile`) changes.

## Editing

```sh
chezmoi diff                       # preview
chezmoi apply                      # deploy and run changed scripts
chezmoi apply --refresh-externals  # also pull git repos in .chezmoiexternal.toml
```

Filenames follow chezmoi's [source state naming][naming]: `dot_` for a leading
dot, `private_` for `0700`, `executable_` for `+x`, `symlink_` for symlinks,
`.tmpl` for templates. Anything added to the repository root that is not meant
for `~` must be listed in `.chezmoiignore`.

[chezmoi]: https://www.chezmoi.io/
[naming]: https://www.chezmoi.io/reference/source-state-attributes/

## References

- [benbrastmckie/.config](https://github.com/benbrastmckie/.config)
- [craftzdog/dotfiles](https://github.com/craftzdog/dotfiles)
- [kaz/dotfiles](https://github.com/kaz/dotfiles)
