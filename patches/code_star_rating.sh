#!/usr/bin/env bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
feature_pack_tarball=$DIR/star_rating/star_rating.tgz
feature_branch_name="feature-book-star-rating"

current_branch=`git branch`
echo "Current Branch: $current_branch"

echo "Creating new feature branch: $feature_branch_name"
git checkout -b $feature_branch_name

echo "Applying code changes..."
pushd $DIR/..
tar -xvf $feature_pack_tarball
popd

echo "Completed."