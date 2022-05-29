# Talos on VMware

- edit `genconfig.sh` and run it.
- Run terraform to deploy control plane and worker nodes
- Initiate the control-cluster
  - add the endpoints (control-plane-nodes) to the `talosconfig`
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
- [ ] MetalLB
- [ ] VMTools
- [ ] 
