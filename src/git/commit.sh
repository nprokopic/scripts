#!/bin/bash

# source "../io/log.sh"

git-commit-changelog() {
    git add ./CHANGELOG.md
    git commit -m "Update CHANGELOG"
}
