
variable "vsphere_server" {}
variable "vsphere_user" {}
variable "vsphere_password" {}

provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "DC1" {
  name = "IRV8"
}

data "vsphere_distributed_virtual_switch" "dvs1" {
  name          = "pn1-ndvs1"
  datacenter_id = data.vsphere_datacenter.DC1.id
}

resource "vsphere_distributed_port_group" "pg1" {
  name                            = "DnVL698-10.95.64.0_25_tf"
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.dvs1.id
  allow_forged_transmits          = true
  allow_mac_changes               = true
  allow_promiscuous               = true
  vlan_id                         = "698"
}
