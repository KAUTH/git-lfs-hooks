#!/bin/bash
#
# This script updates the CHANGELOG.md file accordingly based
# on the changes in the hooks directory
#
#


# exit when any command fails
set -e


# List untracked files in the hooks directory, these will be added new hooks
UNTRACKED_HOOKS=$(git ls-files hooks/ --exclude-standard --others)
UNTRACKED_TXT=""
if [[ -n $UNTRACKED_HOOKS ]]; then
    # Seperate possible multiple outputs by replacing whitespace with whitespace + comma
    SEP_UNTRACKED_HOOKS=$(echo $UNTRACKED_HOOKS | sed 's/ /, /g')

    # Method to write multiline strings in bash, https://linuxhint.com/bash-define-multiline-string-variable/
    UNTRACKED_TXT=$(cat << EOF
\n### Added

- Added new hook(s) from Git LFS ($SEP_UNTRACKED_HOOKS)
- ATTENTION: We need to update the pre-commit-hooks.yaml, README.md files and the tests before releasing.
As it is now, the tests should break when trying to merge this PR.\n
EOF
)
fi

# List modified files in the hooks directory
MODIFIED_HOOKS=$(git diff --name-only hooks/)
MODIFIED_TXT=""
if [[ -n $MODIFIED_HOOKS ]]; then
    # Seperate possible multiple outputs by replacing whitespace with whitespace + comma
    SEP_MODIFIED_HOOKS=$(echo $MODIFIED_HOOKS | sed 's/ /, /g')

    MODIFIED_TXT=$(cat << EOF
\n### Changed

- Updated hooks from Git LFS ($SEP_MODIFIED_HOOKS)\n
EOF
)
fi

# List removed files in the hooks directory
REMOVED_HOOKS=$(git diff --diff-filter D --name-only hooks/)
REMOVED_TXT=""
if [[ -n $REMOVED_HOOKS ]]; then
    # Seperate possible multiple outputs by replacing whitespace with whitespace + comma
    SEP_REMOVED_HOOKS=$(echo $REMOVED_HOOKS | sed 's/ /, /g')

    REMOVED_TXT=$(cat << EOF
\n### Removed

- Removed hook(s) from Git LFS ($SEP_REMOVED_HOOKS)
- ATTENTION: We need to update the pre-commit-hooks.yaml, README.md files and the tests before releasing.
As it is now, the tests should break when trying to merge this PR.
EOF
)
fi

VERSION=$(cat .version)
# Use the ISO 8601 date format
DATE=$(date +'%Y-%m-%d')
VERSION_TXT="## [$VERSION] - $DATE"

if [[ -n UNTRACKED_TXT || -n MODIFIED_TXT || REMOVED_TXT ]]; then
    CHANGELOG_TXT="\n$VERSION_TXT\n$UNTRACKED_TXT$MODIFIED_TXT$REMOVED_TXT"
else
    CHANGELOG_TXT="\n$VERSION_TXT\nSynced with the Git LFS version update (no changes to the hooks)"
fi

# Reference for adding text after a specific string match: https://stackoverflow.com/a/18276534/19234161
# Write changes to the CHANGELOG.md file
changelog_stdout=$(awk -v CHANGELOG_TXT="$CHANGELOG_TXT" '/Unreleased/ { print; print CHANGELOG_TXT; next }1' CHANGELOG.md) # 1> CHANGELOG.md
echo -e "$changelog_stdout" > CHANGELOG.md