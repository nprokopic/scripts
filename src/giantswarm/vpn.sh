#!/bin/bash

start-vpn() {
    local server_id=$1

    # Get VPN config
    local vpn_config_json
    vpn_config_json="$(config_build_json dev/network/vpn/giantswarm.cue)"

    if [ -z "$server_id" ]; then
        server_id="$(json_field "$vpn_config_json" default_server)"
    fi

    local openvpn_config
    openvpn_config="$(json_array_select_by_id "$vpn_config_json" servers "$server_id")"

    local openvpn_config_path
    openvpn_config_path="$(json_field "$openvpn_config" openvpn_config_path)"
    if [ -z "${openvpn_config_path}" ]; then
        log_error "Config for VPN server '$server_id' not found"
        return
    fi

    sudo true
    log_info "Starting $server_id VPN"
    opsctl vpn open --vpn-config-file="$openvpn_config_path" > /dev/null
    export __OPSCTL_VPN_CONNECTION="$server_id"
    log_info "Started $server_id VPN"
}

stop-vpn() {
    if [ -z "$__OPSCTL_VPN_CONNECTION" ]; then
        log_error "VPN connection is down or it's open in another terminal session. Get ovpn config path and try this:
    opsctl vpn close --vpn-config-file=path/to/vpn-config.ovpn"
        return
    fi

    local server_id="$__OPSCTL_VPN_CONNECTION"

    local vpn_config_json
    vpn_config_json="$(config_build_json dev/network/vpn/giantswarm.cue)"

    local openvpn_config
    openvpn_config="$(json_array_select_by_id "$vpn_config_json" servers "$server_id")"

    local openvpn_config_path
    openvpn_config_path="$(json_field "$openvpn_config" openvpn_config_path)"
    if [ -z "${openvpn_config_path}" ]; then
        log_error "Config for VPN server '$server_id' not found"
        return
    fi

    sudo true
    log_info "Closing '${server_id}' VPN connection"
    opsctl vpn close --vpn-config-file="$openvpn_config_path" > /dev/null
    log_info "Closed '${server_id}' VPN connection"
}
