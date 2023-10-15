#!/bin/bash

download-critical-info() {
    output_dir="output"

    # download API server info and logs
    download-info-for-labeled-pods kube-system app.kubernetes.io/name api-server "$output_dir"

    # download controller manager info and logs
    download-info-for-labeled-pods kube-system component kube-controller-manager "$output_dir"

    # download scheduler info and logs
    download-info-for-labeled-pods kube-system component kube-scheduler "$output_dir"

    # download VPA info and logs
    download-info-for-labeled-pods kube-system app.kubernetes.io/name vertical-pod-autoscaler-app "$output_dir"

    # download aws-cloud-controller-manager info and logs
    download-info-for-labeled-pods kube-system app.kubernetes.io/name aws-cloud-controller-manager "$output_dir"

    # download EBS CSI info and logsopen
    download-info-for-labeled-pods kube-system app.kubernetes.io/name aws-ebs-csi-driver "$output_dir"
}

download-info-for-labeled-pods() {
    local namespace="$1"
    local label_key="$2"
    local label_value="$3"
    local output_dir="$4"

    if [ ! -d "$output_dir" ]; then
        mkdir "$output_dir"
        log_info "Created '$output_dir' directory."
    fi

    local output_format="custom-columns=NAME:.metadata.name"

    for pod in $(kubectl get pods -n "$namespace" -l "$label_key=$label_value" -o "$output_format" --no-headers); do
        log_info "Found pod '$pod'."

        # Download manifest
        manifest_file="./$output_dir/$pod.yaml"
        kubectl get pod -n "$namespace" "$pod" -o yaml > "$manifest_file"
        log_info "Downloaded pod manifest to '$manifest_file'."

        # Download pod description
        describe_file="./$output_dir/$pod.describe.txt"
        kubectl describe pod -n "$namespace" "$pod" > "$describe_file"
        log_info "Downloaded pod description to '$describe_file'."

        # Download logs
        log_file="./$output_dir/$pod.log"
        kubectl logs -n "$namespace" "$pod" > "$log_file"
        log_info "Downloaded pod logs to '$log_file'."
    done
}
