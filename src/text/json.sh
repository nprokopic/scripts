#!/bin/bash

json_field() {
    local json_string="$1"
    local field="$2"
    jq -rc ".$field" <<< "$json_string"
}

json_length() {
    local json_string="$1"
    local field="$2"
    jq -rc ".$field | length" <<< "$json_string"
}

json_empty() {
    local json_string="$1"
    local field="$2"

    local array_length
    array_length=$(json_length "$json_string" "$field")

    if (( array_length == 0 )); then
        return 0
    else
        return 1
    fi
}

json_array_select_by_id() {
    local json_string="$1"
    local array_path="$2"
    local id_value="$3"

    jq -rc ".${array_path}[] | select (.id==\"${id_value}\")" <<< "$json_string"
}
