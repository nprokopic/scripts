#!/bin/bash

backup_keepasxc() {
    local src_dir="$NIKOLA_KEEPASSXC_PATH"
    local target_dir="$NIKOLA_KEEPASSXC_BACKUP_PATH"

    # create back directory
    local current_time
    current_time="$(date --utc +'%Y-%m-%d-%H-%M-%SZ')"
    local backup_dir="$target_dir/$current_time"
    if mkdir "$backup_dir"; then
        log_success "Created backup directory $backup_dir"
    else
        log_error "Failed to create backup directory $backup_dir"
        return 1
    fi

    if cp "$src_dir"/*.kdbx "$backup_dir/"; then
        log_success "Backed up vaults to $backup_dir"
    else
        log_error "Failed to back up vaults to $backup_dir"
        return 1
    fi
}
