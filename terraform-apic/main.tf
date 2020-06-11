
# sample code for driving APIC with Terraform
# in this example:
# create: tenant, app profile, epg

# provider block
provider "aci" {
  username = var.apic_user
  password = var.apic_password
  url      = var.apic_url
  insecure = var.apic_insecure
}

resource "aci_tenant" "TENANT1" {
  description = "test tenant created by Terraform"
  name        = "pn-test01"
}

resource "aci_application_profile" "AP01" {
  description = "test AP created by Terraform"
  tenant_dn   = aci_tenant.TENANT1.id
  name        = "pn-test01_AP"
}
