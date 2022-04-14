#!/bin/bash

start-vpn() {
    local connection=$1

    local config_path="$NIKOLA_CONFIG_PATH"
    if [ -z "${config_path}" ]; then
        config_path="$HOME/config"
    fi

    # Get VPN config
    local gs_vpn_config_path="${config_path}/dev/network/vpn/giantswarm.cue"
    local vpn_config_json
    vpn_config_json="$(cue export "$gs_vpn_config_path")"

    if [ -z "$connection" ]; then
        connection="$(echo "$vpn_config_json" | jq -r ".default_server")"
    fi

    local openvpn_config_path
    openvpn_config_path="$(echo "$vpn_config_json" | jq -r ".servers[] | select (.name==\"${connection}\") | .openvpn_config_path")"
    if [ -z "${openvpn_config_path}" ]; then
        log_error "Config for VPN server '$connection' not found"
    fi

    log_begin "Starting $connection VPN"
    opsctl vpn open --vpn-config-file="$openvpn_config_path" > /dev/null
    export __OPSCTL_VPN_CONNECTION="$connection"
    log_end "Started $connection VPN"
}

stop-vpn() {
    if [ -z "$__OPSCTL_VPN_CONNECTION" ]; then
        log_error "VPN connection is down or it's open in another terminal session. Get ovpn config path and try this:
    opsctl vpn close --vpn-config-file=path/to/vpn-config.ovpn"
        return
    fi

    local connection="$__OPSCTL_VPN_CONNECTION"

    local config_path="$NIKOLA_CONFIG_PATH"
    if [ -z "${config_path}" ]; then
        config_path="$HOME/config"
    fi

    # Get VPN config
    local gs_vpn_config_path="${config_path}/dev/network/vpn/giantswarm.cue"
    local vpn_config_json
    vpn_config_json="$(cue export "$gs_vpn_config_path")"

    local openvpn_config_path
    openvpn_config_path="$(echo "$vpn_config_json" | jq -r ".servers[] | select (.name==\"${connection}\") | .openvpn_config_path")"
    if [ -z "${openvpn_config_path}" ]; then
        log_error "Config for VPN server '$connection' not found"
    fi

    log_begin "Closing '${connection}' VPN connection"
    opsctl vpn close --vpn-config-file="$openvpn_config_path" > /dev/null
    log_end "Closed '${connection}' VPN connection"
}
