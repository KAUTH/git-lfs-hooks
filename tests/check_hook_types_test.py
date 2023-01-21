#!/usr/bin/env python3

import unittest
from os import listdir
from os.path import isfile, join


class TestBasics(unittest.TestCase):
    def test_hook_filenames(self) -> None:
        """
        We test that the expected hook files and only them exist.
        
        If a hook is added or removed we need to update the
        .pre-commit-hooks.yaml configuration file.
        """

        expected_hook_files = {
            "post-checkout", "post-commit", "post-merge", "pre-push"
        }

        hooks_path = "git_lfs_hooks/hooks/"
        hook_files = {
            f for f in listdir(hooks_path) if isfile(join(hooks_path, f))
        }

        extra_files = hook_files - expected_hook_files
        missing_files = expected_hook_files - hook_files

        assert (
            hook_files == expected_hook_files
        ), f"extra files: {extra_files}, missing files: {missing_files}"

    
    def test_hook_wrappers(self) -> None:
        """
        We test that the expected hook wrappers and only them exist.
        
        If a hook is added or removed we need to update the existing
        hook wrappers.
        """

        expected_hook_files = {
            "post-checkout", "post-commit", "post-merge", "pre-push"
        }
        expected_wrapper_files = {
            f"{hook}-wrapper" for hook in expected_hook_files
        }

        wrappers_path = "git_lfs_hooks/hook-wrappers/"
        wrapper_files = {
            f for f in listdir(wrappers_path) if isfile(join(wrappers_path, f))
        }

        extra_files = wrapper_files - expected_wrapper_files
        missing_files = expected_wrapper_files - wrapper_files

        assert (
            wrapper_files == expected_wrapper_files
        ), f"extra files: {extra_files}, missing files: {missing_files}"
