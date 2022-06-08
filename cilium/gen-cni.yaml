#!/bin/bash

helm repo update
helm template cilium cilium/cilium --version 1.11.5 --namespace kube-system -f values.yaml > cilium.yaml
cat cm-bgp-config.yaml >> cilium.yaml