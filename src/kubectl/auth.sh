#!/bin/bash

k-is-authenticated() {
    local context_name="$1" # e.g. MC giantswarm-ghost, gs-ghost, or WC gs-ghost-np123
    if kubectl --context "$context_name" cluster-info &>/dev/null; then
        return 0 # success, authenticated
    else
        return 1 # error, not authenticated
    fi
}
