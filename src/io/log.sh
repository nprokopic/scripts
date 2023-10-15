#!/bin/bash

# deprecated
log_success() {
    local message="$1"
    echo "[INF] $(date '+%F %T') $message"
}

log_info() {
    local message="$1"
    echo "[INF] $(date '+%F %T') $message"
}

log_error() {
    local message="$1"
    echo "[ERR] $(date '+%F %T') $message"
}

# deprecated
log_begin() {
    local msg="$1"
    echo "🟠 ${msg}"
}

# deprecated
log_step_end() {
    local msg="$1"
    echo -e '\e[1A\e[K'"🟠 ${msg}"
}

# deprecated
log_end() {
    local msg="$1"
    echo -e '\e[1A\e[K'"🟢 ${msg}"
}
