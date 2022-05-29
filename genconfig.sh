#!/bin/bash

VIP="10.42.12.100"
PORT="6443"

cd config
talosctl gen config vmware-test https://${VIP}:${PORT} --config-patch-control-plane "$(yq eval -I0 -oj ../patches/cp.patch)" --config-patch-worker "$(yq eval -I0 -oj ../patches/worker.patch)"

