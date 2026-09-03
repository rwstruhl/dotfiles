# start-issue

`.local/bin/start-issue` turns a Linear ticket id into a ready workspace: it
resolves the ticket to a branch name, creates the worktree with `wt`, and opens
that worktree as a herdr workspace with three tabs — `claude`, `server`, `vim`.
Every tab is a shell sitting at a prompt in the worktree; nothing is started for
you.

```sh
start-issue CP-3160
```

## No key needed for the paste path

Linear's "Copy git branch name" already contains the ticket id, so a pasted
branch name works as the only argument — no API key, no network:

```sh
start-issue cp-3103-task-status-colors-map
# ticket CP-3103, branch cp-3103-task-status-colors-map
```

Set the key up only if you want `start-issue CP-3103` to resolve the name for
you.

## Where the API key lives

The key is a Linear **personal** API key (`lin_api_…`) from
[linear.app/settings/api](https://linear.app/settings/api), stored in 1Password
as the `api-key` field of the `Linear` item in the `Forerunner` vault:

```sh
LINEAR_OP_REF='op://Forerunner/Linear/api-key'
LINEAR_OP_ACCOUNT='struhl.1password.com'
```

Those are the built-in defaults, so nothing needs exporting. The account matters:
that vault is in the personal 1Password account, and `op read` defaults to the
Forerunner account, where the reference does not resolve. Set
`LINEAR_OP_ACCOUNT=''` if the key ever moves to the default account.

`LINEAR_API_KEY` takes precedence when it is already exported, which skips
1Password entirely.

The OAuth credentials in `Linear OAuth App - Forerunner MCP.` are unrelated —
they are an OAuth client id and secret for the MCP server, which drive a browser
redirect flow rather than a bearer token.

## Branch names

Given a bare ticket id the branch comes from Linear's own suggestion, which
matches what "Copy git branch name" puts on the clipboard — `CP-3103` becomes
`cp-3103-task-status-colors-map`.

Linear derives that slug from the full ticket title, so a long title produces a
long branch. Pass a second argument to override it. A bare slug picks up the
ticket id as a prefix, which keeps the link back to Linear intact:

```sh
start-issue CP-3161 hover-via-select-feature
# branch: cp-3161-hover-via-select-feature
```

The override also skips the API call, so it works with no key and no network.

## Choosing the repository

The worktree is created from the repository containing the current directory.
Use `-C` to branch from a different one and `-b` to pick a base branch other
than the default:

```sh
start-issue -C ~/forerunner/crs-dashboard CP-3160
start-issue -b cp-3160-parent CP-3161
```

`wt` puts the worktree in a sibling directory — `crs-dashboard.cp-3160-…` — and
runs the repository's `pre-start` hooks. In crs-dashboard those hooks install
dependencies and build, so the first run takes a few minutes. The script asks
git where the branch ended up rather than recomputing that path, so a custom
`worktree-path` template in `~/.config/worktrunk/config.toml` keeps working.

A repository whose `.config/wt.toml` hooks have never been approved will stop
with an approval prompt. Review the commands yourself with
`wt config approvals add`; the script deliberately does not pass `--yes`.

## Repeat runs

Both halves are idempotent. An existing worktree for the branch is reused
instead of recreated, and an existing workspace labelled with the ticket id is
focused instead of duplicated — so re-running is how you get back to a ticket
you already started.

Pass `--no-focus` to build the workspace in the background without switching to
it. Outside herdr the script still creates the worktree and prints its path.
