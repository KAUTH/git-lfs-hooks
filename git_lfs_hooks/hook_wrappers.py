#!/usr/bin/env python3

import os

from git_lfs_hooks.utils import run_cmd


def post_checkout(base_path: str) -> str:
    """
    Call post-checkout hook of git-lfs with the required parameters
    """

    # These environment variables are exposed by pre-commit for hooks to
    # consume 
    # Docs: https://pre-commit.com/#pre-commit-for-switching-branches
    rev_before = os.getenv("PRE_COMMIT_FROM_REF")
    ref_after = os.getenv("PRE_COMMIT_TO_REF")
    is_branch_checkout = os.getenv("PRE_COMMIT_CHECKOUT_TYPE")

    # Parameters given to post-checkout hook
    # https://git-scm.com/docs/githooks#_post_checkout
    # and also need to be consumed by git-lfs' hook
    return run_cmd(
        f"{base_path}/hooks/post-checkout " +
        f"{rev_before} {ref_after} {is_branch_checkout}"
    )


def post_commit(base_path: str) -> str:
    """
    Call post-commit hook of git-lfs
    """

    # No parameters are given to post-commit hook
    # and similarly for git-lfs' hook
    # Docs: https://git-scm.com/docs/githooks#_post_commit
    return run_cmd(f"{base_path}/hooks/post-commit")


def post_merge(base_path: str) -> str:
    """
    Call post-merge hook of git-lfs with the required parameter
    """

    # Parameter given to post-merge hook
    # and also needs to be consumed by git-lfs' hook
    # Docs: https://git-scm.com/docs/githooks#_post_merge
    is_squash = os.getenv("PRE_COMMIT_IS_SQUASH_MERGE")

    return run_cmd(f"{base_path}/hooks/post-merge {is_squash}")


def pre_push(base_path: str) -> str:
    """
    Call pre-push hook of git-lfs
    """

    # TODO: Pass stdin and params to hooks/pre-push
    return run_cmd(f"{base_path}/hook-wrappers/pre-push-wrapper")
