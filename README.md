# dotfiles

These dotfiles are intended for macOS.

## Usage

```sh
cd ansible
./apply.sh
```

`apply.sh` installs Homebrew and aqua if needed, then runs the Ansible playbook.
On the first run, or when sudo privileges are required, pass the become password option:

```sh
./apply.sh --ask-become-pass
```

Additional `ansible-playbook` options can be passed through:

```sh
./apply.sh --check
./apply.sh --tags brew,fish
```

## References

- [benbrastmckie/.config](https://github.com/benbrastmckie/.config)
- [craftzdog/dotfiles-public](https://github.com/craftzdog/dotfiles-public)
- [kaz/dotfiles](https://github.com/kaz/dotfiles)
