![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/KAUTH/precommit-mirrors-git-lfs-hooks)
[![GitHub license](https://img.shields.io/github/license/KAUTH/precommit-mirrors-git-lfs-hooks)](https://github.com/KAUTH/precommit-mirrors-git-lfs-hooks/blob/main/LICENSE)

# precommit-mirrors-git-lfs-hooks
Mirror of Git LFS hooks for pre-commit

## General
`pre-commit` documentation: https://pre-commit.com/index.html

Git Large File Storage (LFS) page: https://git-lfs.github.com

## Usage
Add the following to your `.pre-commit-config.yaml` file:

```yaml
-   repo: https://github.com/KAUTH/precommit-mirrors-git-lfs-hooks
    rev: ''  # Use the SHA or tag that you want to point to
    hooks:
    -   id: post-checkout
    -   id: post-commit
    -   id: post-merge
    -   id: pre-push
```

### Notes
- Since running `git lfs install` typically installs all related hooks, we also
advise using all of them in your `pre-commit` configuration file.

- The version in [.version](https://github.com/KAUTH/precommit-mirrors-git-lfs-hooks/blob/main/.version)
corresponds to the mirrored Git LFS version.

## Why
Git LFS installs a series of useful [Git hooks](https://git-scm.com/docs/githooks)
supported by specific commands that are called from the corresponding hook.

Listing the command documentation of the Git LFS hooks' implementation:
- https://github.com/git-lfs/git-lfs/blob/main/docs/man/git-lfs-post-checkout.adoc
- https://github.com/git-lfs/git-lfs/blob/main/docs/man/git-lfs-post-commit.adoc
- https://github.com/git-lfs/git-lfs/blob/main/docs/man/git-lfs-post-merge.adoc
- https://github.com/git-lfs/git-lfs/blob/main/docs/man/git-lfs-pre-push.adoc

If `pre-commit` hooks (the same type as the ones used by Git LFS) are being used in a repository
and we install Git LFS afterward, the latter tool will not be able to automatically install
its hooks.

With this mirror, the `pre-commit` framework and Git LFS can both use the hooks
with no issues.

For the inverse, meaning if Git LFS is already installed and we want to
start using the `pre-commit` framework later, `pre-commit` is able to migrate
the existing hooks (https://pre-commit.com/#running-in-migration-mode). In this
scenario, this mirror is not necessary.

In any case, these hooks can be used to avoid having the Git LFS hooks in migration
mode and can give a holistic view of the available hooks from the `.pre-commit-config.yaml` file.

## License
[MIT License](https://github.com/KAUTH/precommit-mirrors-git-lfs-hooks/blob/main/LICENSE)
