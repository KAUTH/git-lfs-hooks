#!/usr/bin/env python3

import argparse
import sys

from git_lfs_hooks.hook_wrappers import (
    post_checkout,
    post_commit,
    post_merge,
    pre_push,
)
from git_lfs_hooks.utils import get_caller_path


BASE_PATH = get_caller_path()

global_parser = argparse.ArgumentParser(prog="git-lfs-hooks")
subparsers = global_parser.add_subparsers(
    title="subcommands", help="Git LFS hooks"
)


post_checkout_parser = subparsers.add_parser(
    "post-checkout", help="git-lfs post-checkout hook"
)
post_checkout_parser.set_defaults(func=post_checkout)


post_commit_parser = subparsers.add_parser(
    "post-commit", help="git-lfs post-commit hook"
)
post_commit_parser.set_defaults(func=post_commit)


post_merge_parser = subparsers.add_parser(
    "post-merge", help="git-lfs post-merge hook"
)
post_merge_parser.set_defaults(func=post_merge)


pre_push_parser = subparsers.add_parser(
    "pre-push", help="git-lfs pre-push hook"
)
pre_push_parser.set_defaults(func=pre_push)


args = global_parser.parse_args()

def cli() -> None:
    """
    Run CLI program
    """

    if not len(sys.argv) > 1:
        global_parser.error("Not enough arguments")

    args.func(BASE_PATH)
