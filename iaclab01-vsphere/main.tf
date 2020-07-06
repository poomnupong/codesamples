# provider "vsphere" {
#   vsphere_server       = "<vsphere_ip_or_fqdn>"
#   user                 = "<vsphere_user>"
#   password             = "<vsphere_password>"
#   allow_unverified_ssl = true
# }

module "testvm" {
  source           = "./02-workloads/vmw"
  vsphere_server   = "10.95.61.99"
  vsphere_user     = "administrator@vsphere.local"
  vsphere_password = "Admin1234$"
}

terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "cisco-irv8"
    workspaces {
      name = "sample-iaclab01"
    }
  }
}
