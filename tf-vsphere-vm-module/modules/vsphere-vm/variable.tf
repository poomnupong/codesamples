
variable "dc" {
  description = "target vSphere data center"
}

variable "datastore" {
  description = "target datastore"
}

variable "compute_cluster" {
  description = "target compute cluster"
}

variable "resource_pool" {
  description = "target resource pool"
}

variable "portgroup" {
  description = "port group for NIC1, only support single NIC for now"
}

variable "vm_template" {
  description = "VM template to use as clone source"
}

variable "vm_folder" {
  description = "target folder to deploy VM"
}

variable "vm_cpucount" {
  description = "CPU count for the VM"
  default     = 2
}

variable "vm_memory" {
  description = "memory for the VM in MB"
  default     = 4096
}

variable "vm_disksize" {
  description = "VM disk1 size in GB, only support one disk for now"
  default     = 20
}

variable "vm_hostname" {
  description = "hostname for linux VM"
  default     = "terraformvm"
}

variable "vm_domain" {
  description = "domain for linux VM"
  default     = "local"
}

variable "vmcount" {
  description = "number of VM to be deployed"
  default     = 1
}

variable "vmname" {
  description = "name of the VM"
  default     = "terraformvm"
}

variable "vmnameliteral" {
  description = "VM name for single VM deployment"
  default     = ""
}

variable "vmnamesuffix" {
  description = "suffix for VM name"
  default     = ""
}

variable "vm_ipv4_gateway" {
  description = "default gateway"
  default     = null
}

variable "vm_dns_suffix_list" {
  description = "dns search domain for Linux"
  type        = list(string)
  default     = null
}

# variable "vm_dns_domain" {
#   description = "dns server list for Linux"
#   type        = list(string)
#   default     = null
# }

variable "vm_dns_server_list" {
  description = "dns server list for Linux"
  type        = list(string)
  default     = null
}

variable "vm_ipv4_address" {
  description = "ip address on the interface"
  default     = null
}

variable "vm_ipv4_netmask" {
  description = "ip address on the interface"
  default     = 24
}
