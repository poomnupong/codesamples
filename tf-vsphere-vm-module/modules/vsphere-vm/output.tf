output "ipaddr" {
  description = "VM IP address"
  value       = vsphere_virtual_machine.VM1.*.default_ip_address
}
