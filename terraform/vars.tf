
variable vcenter_server {}
variable vsphere_user {}
variable vsphere_password {}

variable datacenter {}
variable datastore {}
variable network {}
variable resource_pool {
    default = "Resources"
}

variable talos_ova_file {
    default = "../image/vmware-amd64.ova"
}

variable folder_name {
    default = "talos"
}
variable vm_control_plane_node_name_prefix {
    default = "control-plane-"
}

variable number_of_vm_control_plane_nodes {
    default = 3
}

variable vm_control_cluster_vip {}
variable vm_control_plane_node_ips {}
variable vm_control_plane_node_default_gateway {}

variable vm_worker_node_name_prefix {
    default = "worker-"
}

variable number_of_vm_worker_nodes {
    default = 3
}

variable vm_worker_node_ips {}
variable vm_worker_node_default_gateway {}
