# GNU Stow quick reference

This repository is a single Stow package. Its directory structure mirrors the
home directory: for example, `.tmux.conf` maps to `~/.tmux.conf`, and
`.config/nvim` maps to `~/.config/nvim`.

Run these commands from the repository root:

```sh
cd ~/dotfiles
```

## Link the dotfiles

Preview the changes first:

```sh
stow --simulate --verbose=2 --target="$HOME" .
```

Create the links:

```sh
stow --verbose=2 --target="$HOME" .
```

The shorter `stow .` also works when the repository is directly inside the
home directory, because Stow uses the package directory's parent as its default
target.

## Add a new dotfile

Move the existing file into this repository, then restow the package. For
example:

```sh
mv ~/.zshrc ~/dotfiles/.zshrc
cd ~/dotfiles
stow --restow --verbose=2 --target="$HOME" .
```

Always inspect the repository copy before committing it so secrets, machine-
specific values, caches, and generated files are not accidentally tracked.

## Agent skills

Global agent skills live in `.agents/skills`, so Stow makes them available at
`~/.agents/skills` on every machine. The adjacent `.skill-lock.json` is also
tracked because the `skills` CLI uses it for source provenance and update
checks.

The global lock file is CLI state, not the source of truth for restoring a new
machine. The committed contents of `.agents/skills` provide portability; after
pulling the repository, run the normal Stow command above. When `skills add`,
`skills remove`, or `skills update` changes the global skill set, review and
commit both the skill files and `.agents/.skill-lock.json`.

## Refresh links

Use `--restow` after adding, moving, or removing files. It removes stale links
owned by this package and creates the links that should currently exist:

```sh
stow --restow --verbose=2 --target="$HOME" .
```

## Remove links

Unstow the package without deleting the files stored in the repository:

```sh
stow --delete --verbose=2 --target="$HOME" .
```

Preview removal with `--simulate`:

```sh
stow --delete --simulate --verbose=2 --target="$HOME" .
```

## Resolve a conflict

Stow stops rather than overwriting a real file at the target. Compare the two
files, preserve the version you want in the repository, and move or remove the
target file before running Stow again.

If an existing target file is identical to the repository copy, Stow can adopt
it into the package:

```sh
stow --adopt --simulate --verbose=2 --target="$HOME" .
stow --adopt --verbose=2 --target="$HOME" .
git diff
```

`--adopt` moves target files into the repository, so review the simulation and
the resulting Git diff carefully.

## Exclude repository-only files

Patterns in `.stow-local-ignore` prevent documentation, Git metadata, logs, and
other repository-only files from being linked into the home directory. Add an
ignore rule whenever a new file or directory belongs in the repository but not
in `~`.

## Useful options

- `--simulate` (`-n`): show what Stow would do without changing anything.
- `--verbose=2` (`-vv`): show the links Stow considers and changes.
- `--target="$HOME"` (`-t "$HOME"`): explicitly select the home directory.
- `--restow` (`-R`): unstow and then stow the package again.
- `--delete` (`-D`): remove links managed by the package.
- `--adopt`: move conflicting target files into the package; use cautiously.
