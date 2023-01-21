#!/usr/bin/env python3

import inspect
import os
import subprocess
import sys
from typing import Any


class CalledProcessError(RuntimeError):
    """
    A simple exception wrapper for the subprocess.CalledProcessError exception
    """

    def __init__(self, error: subprocess.CalledProcessError):
        self.cmd = error.cmd
        self.retcode = error.returncode
        self.stdout = error.stdout.decode()
        self.stderr = error.stderr.decode()


def run_cmd(command: str, **kwargs: Any) -> str:
    """
    Invoke a process to run the given command.

    :param command: the command to be run
    :param kwargs: any other argument to pass to subprocess.run()
    :returns: standard output of the command or raises a
    CalledProcessError exception
    """

    try:
        cmd_list = command.split()
        p = subprocess.run(
            cmd_list, capture_output=True, check=True, **kwargs
        )

        stdout = p.stdout.decode()

    except subprocess.CalledProcessError as e:
        process_error = CalledProcessError(e)
        print(f"[ERROR] {process_error.stdout}")
        
        raise process_error

    return stdout


def get_caller_path() -> str:
    """Get the path of the caller of the called module"""

    return os.path.dirname(inspect.getframeinfo(sys._getframe(1)).filename)
