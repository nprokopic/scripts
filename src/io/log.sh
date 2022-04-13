#!/bin/bash

log_success() {
    local message="$1"
    echo "🟢 $message"
}

log_info() {
    local message="$1"
    echo "🔵 $message"
}

log_error() {
    local message="$1"
    echo "⛔ $message"
}

log_begin() {
    local msg="$1"
    echo "🟠 ${msg}"
}

log_step_end() {
    local msg="$1"
    echo -e '\e[1A\e[K'"🟠 ${msg}"
}

log_end() {
    local msg="$1"
    echo -e '\e[1A\e[K'"🟢 ${msg}"
}
