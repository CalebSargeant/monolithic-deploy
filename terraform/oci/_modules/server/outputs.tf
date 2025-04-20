output "instance_id" {
  description = "ID of the server instance"
  value       = oci_core_instance.this.id
}

output "public_ip" {
  description = "Public IP address of the server instance"
  value       = oci_core_instance.this.public_ip
}

output "private_ip" {
  description = "Private IP address of the server instance"
  value       = oci_core_instance.this.private_ip
}

output "instance_state" {
  description = "Current state of the server instance"
  value       = oci_core_instance.this.state
}

output "edge_router_id" {
  description = "ID of the edge router route table"
  value       = var.edge_private_ip != "" ? oci_core_route_table.edge_router[0].id : null
}
