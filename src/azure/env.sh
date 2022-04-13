#!/bin/bash

function set-azure-env-vars() {
    local tenant_id="$1"
    local subscription_id="$2"
    local client_id="$3"
    local client_secret="$4"

    # use public cloud
    export AZURE_ENVIRONMENT="AzurePublicCloud"
    export AZURE_LOCATION="westeurope"

    export AZURE_TENANT_ID="$tenant_id"
    export AZURE_SUBSCRIPTION_ID="$subscription_id"
    export AZURE_CLIENT_ID="$client_id"
    export AZURE_CLIENT_SECRET="$client_secret"

    AZURE_SUBSCRIPTION_ID_B64="$(echo -n "$subscription_id" | base64 | tr -d '\n')"
    export AZURE_SUBSCRIPTION_ID_B64

    AZURE_TENANT_ID_B64="$(echo -n "$tenant_id" | base64 | tr -d '\n')"
    export AZURE_TENANT_ID_B64

    AZURE_CLIENT_ID_B64="$(echo -n "$client_id" | base64 | tr -d '\n')"
    export AZURE_CLIENT_ID_B64

    AZURE_CLIENT_SECRET_B64="$(echo -n "$client_secret" | base64 | tr -d '\n')"
    export AZURE_CLIENT_SECRET_B64

    export AZURE_CONTROL_PLANE_MACHINE_TYPE="Standard_D4s_v3"
    export AZURE_NODE_MACHINE_TYPE="Standard_D4s_v3"

    # TODO: check if Azure CLI is installed
    az account set --subscription "$subscription_id"
}
