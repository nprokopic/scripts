#!/bin/bash

keepassxc_show_password() {
    local database_path="$1"
    local database_password="$2"
    local entry_path="$3"
    local entry_attribute="$4"

    echo "$database_password" | keepassxc-cli show \
        "$database_path" \
        "$entry_path" \
        --attributes "$entry_attribute" \
        --show-protected \
        --quiet
}
