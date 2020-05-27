

data "vsphere_datacenter" "DC" {
  name = var.dc
}

data "vsphere_datastore" "DATASTORE" {
  name          = var.datastore
  datacenter_id = "${data.vsphere_datacenter.DC.id}"
}

data "vsphere_compute_cluster" "CLUSTER" {
  name          = var.compute_cluster
  datacenter_id = "${data.vsphere_datacenter.DC.id}"
}

data "vsphere_resource_pool" "RESOURCEPOOL" {
  name          = var.resource_pool
  datacenter_id = "${data.vsphere_datacenter.DC.id}"
}

data "vsphere_network" "NETWORK" {
  name          = var.portgroup
  datacenter_id = "${data.vsphere_datacenter.DC.id}"
}

data "vsphere_virtual_machine" "VM_TEMPLATE" {
  name          = var.vm_template
  datacenter_id = "${data.vsphere_datacenter.DC.id}"
}

resource "vsphere_virtual_machine" "VM1" {
  count = var.vmcount
  # name                = var.vmname
  name                = "%{if var.vmnameliteral != ""}${var.vmnameliteral}%{else}${var.vmname}${count.index + 1}${var.vmnamesuffix}%{endif}"
  resource_pool_id    = data.vsphere_resource_pool.RESOURCEPOOL.id
  datastore_id        = data.vsphere_datastore.DATASTORE.id
  num_cpus            = var.vm_cpucount
  memory              = var.vm_memory
  guest_id            = data.vsphere_virtual_machine.VM_TEMPLATE.guest_id
  scsi_type           = data.vsphere_virtual_machine.VM_TEMPLATE.scsi_type
  folder              = var.vm_folder
  sync_time_with_host = "true"
  network_interface {
    network_id   = data.vsphere_network.NETWORK.id
    adapter_type = data.vsphere_virtual_machine.VM_TEMPLATE.network_interface_types[0]
  }
  disk {
    label = "disk0"
    size  = var.vm_disksize
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.VM_TEMPLATE.id
    customize {
      network_interface {
        # dns_domain = var.vm_dns_domain
        # dns_server_list = ["8.8.8.8", "4.4.4.4"]
        ipv4_address = var.vm_ipv4_address
        ipv4_netmask = var.vm_ipv4_netmask
      }
      linux_options {
        host_name = var.vm_hostname
        domain    = var.vm_domain
      }
      ipv4_gateway    = var.vm_ipv4_gateway
      dns_suffix_list = var.vm_dns_suffix_list
      dns_server_list = var.vm_dns_server_list
    }
  }
}
