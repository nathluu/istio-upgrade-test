#!/usr/bin/env bash
set -euxo pipefail

CLUSTER_NETWORK=""
CLUSTER="Kubernetes" #This is a fixed value

istioctl operator init

cat <<EOF > vm-cluster.yaml
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
metadata:
  name: istio
spec:
  profile: default
  hub: docker.io/nathluu
  tag: 1.16.2
  values:
    global:
      meshID: mesh1
      multiCluster:
        clusterName: "${CLUSTER}"
      network: "${CLUSTER_NETWORK}"
  meshConfig:
    accessLogFile: /dev/stdout
  components:
    base:
      enabled: true
    pilot:
      enabled: true
    ingressGateways:
    - name: istio-ingressgateway
      enabled: true

EOF

istioctl install -f vm-cluster.yaml -y

#if ! kubectl apply -f addons/; then
#  sleep 5 && kubectl apply -f addons/
#fi

# kubectl label namespace default istio-injection=enabled
