# Talos on VMware

- Download Talos ova for VMware (`./image/`)
- Adjust `values.yaml` and `cm-bgp-config.yaml` in `./cilium/`
  - Create CNI config `./cilium/gen-cni.sh`
  - Update the gist and adjust the url in `./config/cp.patch` if changed.
- edit `genconfig.sh` (VIP and Port) and run it.
- Run terraform to deploy control plane and worker nodes
- Initiate the control-cluster
  - Add the endpoints (control-plane-nodes) to the `talosconfig`
  - Run the bootstrap on one of the control-plane-nodes `-n`
    ```bash
    talosctl --talosconfig talosconfig bootstrap -n 10.42.12.19
    ```
    Patience +/- 15min, check the bootprocess with
    ```bash
    talosctl --talosconfig talosconfig health -n 10.42.12.19
    ```


## TODO

- [ ] Option for static IP addresses
- [ ] Cilium
- [ ] VMTools
- [ ] ...
