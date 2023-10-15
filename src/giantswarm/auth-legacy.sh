#!/bin/bash

goto-legacy() {
    local mc="$1"
    local wc="$2"

    if [[ -z $mc ]] && [[ -z "$wc" ]]; then
        log_error "Please pass MC or both MC and WC."
        return
    fi

    # login to MC/WC
    if [ -z "$wc" ]; then
        __login-mc-legacy "$mc"
    else
        __login-wc-legacy "$mc" "$wc"
    fi

    # login to cloud provider
    # __goto-cloud "$mc" "$wc"

    export GG_MANAGEMENT_CLUSTER="$mc"
}

__login-mc-legacy() {
    local mc="$1"

    local desired_context
    desired_context="giantswarm-$mc"

    if k-is-authenticated "$desired_context"; then
        log_info "Already logged in to $mc"
        if [[ $(kubectl config current-context) != "$desired_context" ]]; then
            kubectl config use-context "$desired_context" >/dev/null
            log_info "Switched to context $desired_context"
        fi
    else
        if opsctl create kubeconfig -i "$mc" --ttl 1; then
            log_info "Logged in to $mc"
        else
            log_error "Failed to login to MC $mc"
        fi
    fi

    gsctl select endpoint "$mc" >/dev/null
    log_info "Selected gsctl endpoint $mc"
}

__login-wc-legacy() {
    local mc="$1"
    local wc="$2"

#    local desired_context
#    desired_context="giantswarm-$mc"
    #__login-mc-legacy "$mc"

    gsctl create kubeconfig --cluster="$wc" --certificate-organizations system:masters
}
