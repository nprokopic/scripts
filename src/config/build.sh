#!/bin/bash

config_file_exists() {
    local config_dir="$NIKOLA_CONFIG_PATH"
    if [ -z "${config_dir}" ]; then
        config_dir="$HOME/config"
    fi

    local config_relative_path="$1"
    local config_path="$config_dir/$config_relative_path"

    if [ -f "$config_path" ]; then
        return 0
    else
        return 1
    fi
}


config_build_json() {
    local config_dir="$NIKOLA_CONFIG_PATH"
    if [ -z "${config_dir}" ]; then
        config_dir="$HOME/config"
    fi

    local config_relative_path="$1"
    local config_path="$config_dir/$config_relative_path"

    # Get VPN config
    cue export "$config_path"
}
