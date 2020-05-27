
provider "vsphere" {
  vsphere_server       = "<vsphere_ip_or_fqdn>"
  user                 = "<vsphere_user>"
  password             = "<vsphere_password>"
  allow_unverified_ssl = true
}

module "test01" {
  source = "./modules/vsphere-vm"

  dc              = "IRV8"
  datastore       = "vsanDatastore"
  compute_cluster = "PN01"
  resource_pool   = "pnupong-02"

  # port group for NIC1
  portgroup = "common|Main_AP|SUBN-192.168.3.0_24_EPG"

  # source template for cloning
  vm_template = "template-ubuntu1604-20191020"

  vmcount            = 1
  vmname             = "pn-gitlab1"
  vm_folder          = "/pnupong-02"
  vm_cpucount        = 2
  vm_memory          = 4096
  vm_disksize        = 20
  vm_hostname        = "irv-pn-gitlab1"
  vm_domain          = "cisco.com"
  vm_dns_server_list = ["171.70.168.183", "10.95.61.110"]
  vm_ipv4_address    = "192.168.3.95"
  vm_ipv4_netmask    = 24
  vm_ipv4_gateway    = "192.168.3.1"
}
