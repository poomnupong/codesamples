
variable "vsphere_server" {}
variable "vsphere_user" {}
variable "vsphere_password" {}

provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "DC" {
  name = "IRV8"
}

data "vsphere_datastore" "DATASTORE" {
  name          = "vsanDatastore"
  datacenter_id = "${data.vsphere_datacenter.DC.id}"
}

data "vsphere_compute_cluster" "CLUSTER" {
  name          = "PN01"
  datacenter_id = "${data.vsphere_datacenter.DC.id}"
}

data "vsphere_resource_pool" "RESOURCEPOOL" {
  name          = "pnupong-00"
  datacenter_id = "${data.vsphere_datacenter.DC.id}"
}

data "vsphere_network" "NETWORK" {
  name          = "common|Main_AP|SUBN-192.168.3.0_24_EPG"
  datacenter_id = "${data.vsphere_datacenter.DC.id}"
}

data "vsphere_virtual_machine" "VM_TEMPLATE" {
  name          = "template-ubuntu1604-20191020"
  datacenter_id = "${data.vsphere_datacenter.DC.id}"
}

data "vsphere_tag_category" "category" {
  name = "vm_owner"
}

data "vsphere_tag" "tag" {
  name        = "pnupong"
  category_id = data.vsphere_tag_category.category.id
}

resource "vsphere_virtual_machine" "VM1" {
  count               = 1
  name                = "pn-tftest-${count.index + 1}"
  resource_pool_id    = data.vsphere_resource_pool.RESOURCEPOOL.id
  datastore_id        = data.vsphere_datastore.DATASTORE.id
  num_cpus            = 2
  memory              = 4096
  guest_id            = data.vsphere_virtual_machine.VM_TEMPLATE.guest_id
  scsi_type           = data.vsphere_virtual_machine.VM_TEMPLATE.scsi_type
  folder              = "/pnupong-02"
  tags                = [data.vsphere_tag.tag.id]
  sync_time_with_host = "true"
  network_interface {
    network_id   = data.vsphere_network.NETWORK.id
    adapter_type = data.vsphere_virtual_machine.VM_TEMPLATE.network_interface_types[0]
  }
  disk {
    label = "disk0"
    size  = 20
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.VM_TEMPLATE.id
    customize {
      network_interface {
        # dns_domain      = "cisco.com"
        # dns_server_list = ["8.8.8.8", "4.4.4.4"]
        # ipv4_address    = "192.168.2.96"
        # ipv4_netmask    = "24"
      }
      linux_options {
        host_name = "pn2-tftest-${count.index + 1}"
        domain    = "local"
      }
      # ipv4_gateway = "192.168.2.1"
    }
  }
}
