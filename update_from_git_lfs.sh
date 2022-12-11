#!/bin/bash
#
# ...
#


# exit when any command fails
set -e


echo "Installing git-lfs..."
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash


echo "Checking git-lfs version:"
LFS_CURRENT_VERSION=$(cat .version)
# raw `git lfs --version` output looks something like: git-lfs/3.3.0 (GitHub; linux amd64; go 1.19.3; git 77deabdf)
LFS_LATEST_VERSION=$(git lfs --version | awk '{print $1}' | awk -F/ '{print $2}')

if dpkg --compare-versions $LFS_LATEST_VERSION eq $LFS_CURRENT_VERSION; then
    # We assume that if the git-lfs version is unchanged then
    # there are no changes to its Git hooks (this makes also
    # the workflow shorter when there are no updates)
    echo "git-lfs version is unchanged ($LFS_CURRENT_VERSION). Exiting..."
    exit 0
fi

if dpkg --compare-versions $LFS_LATEST_VERSION lt $LFS_CURRENT_VERSION; then
    echo "git-lfs latest version ($LFS_LATEST_VERSION) is smaller that our current version ($LFS_LATEST_VERSION)"
    echo "Proceed to investigate. Exiting..."
    exit 1
fi

if dpkg --compare-versions $LFS_LATEST_VERSION gt $LFS_CURRENT_VERSION; then
    echo "git-lfs has a new version ($LFS_LATEST_VERSION)"
    echo "Proceeding to check hook files and update hook version..."
fi


echo "Initializing git-lfs in tmp directory..."
mkdir tmp
pushd tmp
git init
git lfs install
popd


echo "Copying files to hooks dir..."
cp -a tmp/.git/hooks/. hooks/


echo "Updating .version file..."
echo $LFS_LATEST_VERSION > .version
