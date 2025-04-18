output "vcn_id" {
  description = "ID of the Virtual Cloud Network"
  value       = oci_core_virtual_network.this.id
}

output "subnet_id" {
  description = "ID of the subnet"
  value       = oci_core_subnet.this.id
}

output "network_security_group_id" {
  description = "ID of the Network Security Group"
  value       = oci_core_network_security_group.this.id
}

output "ssh_public_key" {
  description = "SSH public key used for instances"
  value       = file(var.ssh_public_key_path)
}

output "network_id" {
  description = "ID of the Virtual Cloud Network (alias for vcn_id)"
  value       = oci_core_virtual_network.this.id
}

output "ssh_key" {
  description = "SSH public key used for instances (alias for ssh_public_key)"
  value       = file(var.ssh_public_key_path)
}