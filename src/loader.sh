#!/bin/bash

load() {
    local SOURCE
    local DIR

    # Attribution: https://stackoverflow.com/a/246128/4727982
    # TODO: see https://creativecommons.org/licenses/by-sa/4.0/
    #       If supplied, you must provide the name of the creator and attribution parties, a
    #       copyright notice, a license notice, a disclaimer notice, and a link to the material.
    #       CC licenses prior to Version 4.0 also require you to provide the title of the material
    #       if supplied, and may have other slight differences.
    SOURCE="${BASH_SOURCE[0]}"
    while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
      DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
      SOURCE="$(readlink "$SOURCE")"
      [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    done
    DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

    source "$DIR/io/loader.sh"
    source "$DIR/env/loader.sh"
    source "$DIR/git/loader.sh"
    source "$DIR/kubectl/loader.sh"
    source "$DIR/giantswarm/loader.sh"
    source "$DIR/secrets/loader.sh"
    source "$DIR/backup/loader.sh"
    source "$DIR/azure/loader.sh"
}

load
unset -f load
