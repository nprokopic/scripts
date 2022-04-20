#!/bin/bash

# source "../io/log.sh"

git-get-last-commit-message() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        git log -1 --pretty=%B | xargs
    else
        log_error "Current directory is not a git repo."
    fi
}

git-squash-branch() {
    # show preview message
    log_info "Squashing not supported yet"
    return

    if git rev-parse --git-dir > /dev/null 2>&1; then
        : # all good
    else
        log_error "Current directory is not a git repo."
        return
    fi

    local base_branch
    base_branch="$1"
    if [ -z "$base_branch" ]; then
        log_error "Base branch not specified."
        return
    fi

    # TODO check if base_branch is actually a git branch


    local message
    message="$2"

    # Trim string and remove redundant whitespaces
    message="$(echo "$message" | xargs)"

    if [ -z "$message" ]; then
        message="$(git-get-last-commit-message)"
    fi

    # git checkout yourBranch
    
    local current_branch
    current_branch="$(git branch --show-current)"

    # DON'T USE MASTER HERE
    git reset "$(git merge-base "$base_branch" "$current_branch")"
    
    git add -A
    git commit -m "$message"
}
