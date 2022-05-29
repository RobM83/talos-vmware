provider "vsphere" {
    vsphere_server = var.vcenter_server
    user           = var.vsphere_user
    password       = var.vsphere_password

    allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
    name = var.datacenter
}

data "vsphere_datastore" "datastore" {
    name            = var.datastore
    datacenter_id   = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
    name            = var.network
    datacenter_id   = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "resource_pool" {
    name            = var.resource_pool
    datacenter_id   = data.vsphere_datacenter.dc.id
}

# ------
# Content Library
# ------

resource "vsphere_content_library" "library" {
    name            = "talos"
    description     = "Talos OVA File(s)"
    storage_backing = [data.vsphere_datastore.datastore.id]
}

resource "vsphere_content_library_item" "library_item" {
    name        = "talos"
    description = "Talos OVA File"
    file_url    = var.talos_ova_file
    library_id  = resource.vsphere_content_library.library.id 
}

# ------
# Control VM
# ------

data "template_file" "talos_config_controlplane" {
  template = file("../config/controlplane.yaml")
  vars = {
    IPADDRESS  = "IPADDRESS" //Little workaround to make it dynamic in the VM resource
    GATEWAY    = var.vm_control_plane_node_default_gateway
    VIPADDRESS = var.vm_control_cluster_vip
  }
}

resource "vsphere_folder" "folder" {
    path            = var.folder_name
    type            = "vm"
    datacenter_id   = data.vsphere_datacenter.dc.id
}

//Control plane
resource "vsphere_virtual_machine" "controlplanes" {
    //count               = var.number_of_vm_control_plane_nodes
    count               = length(var.vm_control_plane_node_ips)
    name                = format("%s%s", var.vm_control_plane_node_name_prefix, count.index + 1)
    datastore_id        = data.vsphere_datastore.datastore.id
    resource_pool_id    = data.vsphere_resource_pool.resource_pool.id
    folder              = var.folder_name

    num_cpus        = 2
    memory          = 4096
    //guest_id        = "other3xLinux64Guest"

    network_interface {        
        network_id = data.vsphere_network.network.id
    }

    enable_disk_uuid = true

    extra_config = {
        "guestinfo.talos.config" = base64encode(replace(data.template_file.talos_config_controlplane.rendered, "IPADDRESS", var.vm_control_plane_node_ips[count.index]))
    }
    
    disk {
        label   = "disk0"
        size = 10
        thin_provisioned = true
    }

    clone {
        template_uuid = resource.vsphere_content_library_item.library_item.id
    }

    wait_for_guest_net_timeout = 0 //Otherwise Terraform hangs due to lack of vm tools ?
}

# ------
# Worker VM
# ------

data "template_file" "talos_config_worker" {
  template = file("../config/worker.yaml")
  vars = {
    IPADDRESS  = "IPADDRESS" //Little workaround to make it dynamic in the VM resource
    GATEWAY    = var.vm_worker_node_default_gateway
  }
}


resource "vsphere_virtual_machine" "workers" {
    count               = length(var.vm_worker_node_ips)
    name                = format("%s%s", var.vm_worker_node_name_prefix, count.index + 1)
    datastore_id        = data.vsphere_datastore.datastore.id
    resource_pool_id    = data.vsphere_resource_pool.resource_pool.id
    folder              = var.folder_name

    num_cpus        = 4
    memory          = 8192
    //guest_id        = "other3xLinux64Guest"

    network_interface {        
        network_id = data.vsphere_network.network.id
    }

    enable_disk_uuid = true
    extra_config = {
        "guestinfo.talos.config" = base64encode(replace(data.template_file.talos_config_worker.rendered, "IPADDRESS", var.vm_worker_node_ips[count.index]))
    }
    
    disk {
        label   = "disk0"
        size = 10
        thin_provisioned = true
    }

    clone {
        template_uuid = resource.vsphere_content_library_item.library_item.id
    }

    wait_for_guest_net_timeout = 0 //Otherwise Terraform hangs due to lack of vm tools ?
}