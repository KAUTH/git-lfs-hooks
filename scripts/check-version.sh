#!/bin/bash
#
# This script checks if the version in .version changed in the current commit
# comparing to the previous commit
#


# exit when any command fails
set -e

VERSON_DIFF=$(git diff HEAD HEAD~ .version)

if [[ -n $VERSON_DIFF ]]; then
    echo ".version has changed"
else
    echo ".version has not changed"
    exit 1
fi
