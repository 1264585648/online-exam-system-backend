# Upstream

## Addresses

- origin: this fork on the logged-in GitHub account
- upstream: see the repository-specific URL below
- upstream default branch: `master`
- our default development branch: `main`

This repo upstream: https://github.com/Alanosy/online-exam-system-backend

`master` is kept. Do not delete it. Do not delete the GitHub fork relationship.

## Branch roles

- `upstream/master`: original author code
- `origin/main`: long-lived product trunk. First `main` was created equal to upstream `master` at fork time.
- `feature/*`: later product work
- `chore/upstream-sync-YYYYMMDD`: branch created by the sync workflow when upstream has new commits

## Sync model

```text
upstream/master
  -> detect new commits
  -> branch chore/upstream-sync-YYYYMMDD
  -> pull request into main
  -> CI
  -> human or agent review
  -> origin/main
```

This is not a scheduled merge into `main`. The workflow never force-pushes `main`, never auto-merges `main`, and never resolves conflicts with `theirs`.

Workflow file: `.github/workflows/upstream-sync.yml`

- Daily cron: `0 2 * * *` (UTC)
- Manual: `workflow_dispatch`
- No new commits on `upstream/master` means the job exits. It does not open an empty PR.

PR title: `chore: sync upstream Alanosy/master`

PR body includes upstream start commit, latest upstream commit, new commit count, whether conflicts exist, CI status, and sync time.

## Manual fetch

```bash
git remote add upstream <upstream-url>
git fetch upstream master
git log --oneline main..upstream/master
```

To open a local review branch:

```bash
git checkout -b chore/upstream-sync-$(date -u +%Y%m%d) main
git merge upstream/master
```

## Conflicts

If the sync PR reports conflicts:

1. Leave the PR open.
2. Check out the `chore/upstream-sync-*` branch.
3. Resolve conflicts by hand. Do not accept upstream over product changes blindly.
4. Push the same branch. Do not force-push `main`.
5. Merge only after CI and review.
