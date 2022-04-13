#!/bin/bash

function load-env() {
    local env_name="$1"

    if [ -z "${env_name}" ]; then
        log_error "Environment name not specified"
        return
    fi

    local config_path="$NIKOLA_CONFIG_PATH"
    if [ -z "${config_path}" ]; then
        config_path="$HOME/config"
    fi

    local env_file_path="${config_path}/dev/env/${env_name}.cue"

    if [ ! -f "$env_file_path" ]; then
        log_error "Environment $env_name not found"
        return
    fi

    local config_json
    config_json="$(cue export "$env_file_path")"

    # load secrets from keepassxc vault
    local database_path
    database_path="$(echo "$config_json" | jq -r ".secrets.from_vault.database_path")"
    local group_path
    group_path="$(echo "$config_json" | jq -r ".secrets.from_vault.group_path")"

    local database_password
    echo -n "🔐 Enter password for keepassxc database '$database_path': "
    read -rs database_password
    echo

    # load plain env vars
    local vars_count
    vars_count=$(echo "$config_json" | jq -r ".vars | length")
    if (( vars_count > 0 )); then
        for var_name in $(echo "$config_json" | jq -r ".vars | keys | .[]"); do
            local var_value
            var_value="$(echo "$config_json" | jq -r ".vars.${var_name}")"
            export "$var_name"="$var_value"
            log_success "Set $var_name"
        done
    fi

    for secret_entry in $(echo "$database_password" | keepassxc-cli ls "$database_path" "$group_path" --quiet); do
        log_begin "Loading $secret_entry"
        local var_value
        var_value="$(keepassxc_show_password \
            "$database_path" \
            "$database_password" \
            "$group_path/$secret_entry" \
            "Password")"
        export "$secret_entry"="$var_value"
        log_end "Set $secret_entry secret"
    done
}
