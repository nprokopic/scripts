#!/bin/bash

kubectl-search-pods () {
    pattern="$1"
    kubectl get pods -A | grep "$pattern"
}

alias pods=kubectl-search-pods

kubectl-remove-finalizers () {
    local namespace="$1"
    local type="$2"
    local object="$3"

    kubectl get -n "$namespace" "$type" "$object" -o=json | \
      jq '.metadata.finalizers = null' | kubectl apply -f -
}
