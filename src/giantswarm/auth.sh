#!/bin/bash

goto() {
    local mc="$1"
    local wc="$2"

    if [[ -z $mc ]] && [[ -z "$wc" ]]; then
        log_error "Please pass MC or both MC and WC."
        return
    fi

    # login to MC/WC
    if [ -z "$wc" ]; then
        __login-mc "$mc"
    else
        __login-wc "$mc" "$wc"
    fi

    # login to cloud provider
    # __goto-cloud "$mc" "$wc"

    export GG_MANAGEMENT_CLUSTER="$mc"
}

__login-mc() {
    local mc="$1"

    local desired_context
    desired_context="gs-$mc"

    if k-is-authenticated "$desired_context"; then
        log_info "Already logged in to $mc"
        if [[ $(kubectl config current-context) != "$desired_context" ]]; then
            kubectl config use-context "$desired_context" >/dev/null
            log_info "Switched to context $desired_context"
        else
            log_info "Context $desired_context already selected"
        fi
    else
        if opsctl login "$mc"; then
            log_info "Logged in to $mc"
        else
            log_error "Failed to login to MC $mc"
        fi
    fi
}

__login-wc() {
    local mc="$1"
    local wc="$2"

    local desired_context
    desired_context="gs-$mc-$wc"

    if k-is-authenticated "$desired_context"; then
        log_info "Already logged in to WC $mc/$wc"
        if [[ $(kubectl config current-context) != "$desired_context" ]]; then
            kubectl config use-context "$desired_context" >/dev/null
            log_info "Switched to context $desired_context"
        else
            log_info "Context $desired_context already selected"
        fi
    else
        if opsctl login "$mc" "$wc"; then
            log_info "Logged in to WC $mc/$wc"
        else
            log_error "Failed to login to WC $mc/$wc"
        fi
    fi
}

__goto-cloud() {
    local mc="$1"
    local wc="$2"

    case $mc in
        ghost | godsmack | gollum | gremlin)
            export GG_INFRA_PROVIDER="azure"
            echo "📣 Setting GiantSwarm Azure subscription for Azure CLI 🏁"
            az account set -s "$GIANTSWARM_AZURE_SUBSCRIPTION"
            ;;
        gaia | gauss | ginger | giraffe | gorilla)
            export GG_INFRA_PROVIDER="aws"
            echo "⛔ AWS CLI not configured."
            ;;
        *)
            echo "⛔ Cloud provider CLI not configured."
            ;;
    esac
}
