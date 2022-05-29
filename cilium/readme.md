helm repo update
helm template cilium cilium/cilium --version 1.11.4 --namespace kube-system --set ipam.mode=kubernetes > cilium.yaml
