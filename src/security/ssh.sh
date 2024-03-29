#!/bin/bash

load-ssh-key() {
    local key_id=$1

    # Get SSH config
    if ! config_file_exists security/ssh/keys.cue; then
        log_error "SSH config file not found"
        return
    fi

    local ssh_config_json
    ssh_config_json="$(config_build_json security/ssh/keys.cue)"

    if [ -z "$key_id" ]; then
        key_id="$(json_field "$ssh_config_json" default_key)"
    fi

    local ssh_config
    ssh_config="$(json_array_select_by_id "$ssh_config_json" keys "$key_id")"
    if [ -z "$ssh_config" ]; then
        log_error "Config for SSH key $key_id not found"
        return
    fi

    local ssh_key_file
    ssh_key_file="$(json_field "$ssh_config" name)"

    local ssh_key_comment
    ssh_key_comment="$(json_field "$ssh_config" comment)"

    ssh_key_file_path="${HOME}/.ssh/${ssh_key_file}"

    if [[ $SSH_AUTH_SOCK == "/run/user/1000/keyring/ssh" ]]; then
        log_info "Using Gnome keyring."
    else
        log_error "SSH_AUTH_SOCK not pointing to Gnome keyring, but to '$SSH_AUTH_SOCK'. Load key manually (with ssh-add command)"
        return
    fi

    if [ -z "$(ssh-add -l | grep "$ssh_key_comment")" ] ; then
        (( ssh_key_ttl=24*60*60 ))

        if [ "$key_id" == "yka" ] || [ "$key_id" == "ykc" ]; then
            log_info "Adding SSH security key"
            ssh-add -K -t "$ssh_key_ttl" "$ssh_key_file_path"
            log_info "Added SSH security key"
        else
            log_info "Adding SSH key"
            ssh-add -t "$ssh_key_ttl" "$ssh_key_file_path"
            log_info "Added SSH key"
        fi
    else
        log_info "SSH key '$key_id' is already loaded."
    fi
}

function stop-ssh-agent {
    if [ -z "$SSH_AGENT_PID" ] || [ "$(ps -p $SSH_AGENT_PID | grep [s]sh-agent | grep -v "<defunct>" | wc -l)" -eq 0 ]; then
        log_info "ssh-agent was already stopped."
    else
        eval "$(ssh-agent -k)" > /dev/null 2>&1
        log_info "ssh-agent stopped."
    fi
}

function clear-ssh-agent {
    ssh-add -D > /dev/null 2>&1
    log_info "All manually added keys removed from ssh-agent"
}
