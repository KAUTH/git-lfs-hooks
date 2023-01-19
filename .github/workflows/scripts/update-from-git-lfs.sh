#!/bin/bash
#
# This script checks the latest git-lfs version and updates
# the Git hooks and .version file accordingly
#


# exit when any command fails
set -e


echo "Checking the git-lfs version:"
LFS_CURRENT_VERSION=$(cat .version)
# https://github.com/git-lfs/git-lfs/releases/latest redirects to a URL format of https://github.com/git-lfs/git-lfs/releases/tag/vx.y.z 
LFS_LATEST_VERSION_STRING=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/git-lfs/git-lfs/releases/latest | awk -F/ '{print $NF}')
LFS_LATEST_VERSION="${LFS_LATEST_VERSION_STRING:1}"

if dpkg --compare-versions $LFS_LATEST_VERSION eq $LFS_CURRENT_VERSION; then
    # We assume that if the git-lfs version is unchanged then
    # there are no changes to its Git hooks (this makes also
    # the workflow's running durations shorter when there are no updates)
    echo "git-lfs version is unchanged ($LFS_CURRENT_VERSION). Exiting..."
    exit 1
fi

if dpkg --compare-versions $LFS_LATEST_VERSION lt $LFS_CURRENT_VERSION; then
    echo "git-lfs latest version ($LFS_LATEST_VERSION) is lower than our current version ($LFS_CURRENT_VERSION)"
    echo "Proceed to investigate. Exiting..."
    exit 1
fi

if dpkg --compare-versions $LFS_LATEST_VERSION gt $LFS_CURRENT_VERSION; then
    echo "git-lfs has a new version ($LFS_LATEST_VERSION)"
    echo "Proceeding to check the hook files and update the hook version..."
fi


echo "Installing git-lfs..."
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash

# Another way to get the git-lfs version (not needed for now)
## raw `git lfs --version` output looks something like: git-lfs/3.3.0 (GitHub; linux amd64; go 1.19.3; git 77deabdf)
# LFS_LATEST_VERSION=$(git lfs --version | awk '{print $1}' | awk -F/ '{print $2}')

echo "Initializing git-lfs in 'tmp' directory..."
mkdir tmp
pushd tmp
git init
git lfs install
# remove all sample Git hooks if they exist
rm -f .git/hooks/*.sample
popd


echo "Copying files to 'hooks' dir..."
# -p is necessary since the first time hooks/ is empty and git does not track
# emptry directories, thus it does not exist in the repo
mkdir -p hooks/ && cp -a tmp/.git/hooks/. hooks/


echo "Updating the '.version' file..."
echo $LFS_LATEST_VERSION > .version
