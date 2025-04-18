provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  region       = var.region
}

# Create an OCI compartment
resource "oci_identity_compartment" "compartment" {
  compartment_id = var.tenancy_ocid
  name           = var.compartment_name
  description    = var.compartment_description
}

# Enable a budget for the compartment
resource "oci_budget_budget" "budget" {
  amount         = var.budget_amount
  compartment_id = var.tenancy_ocid
  reset_period   = "MONTHLY"
  target_type    = "COMPARTMENT"
  targets        = [oci_identity_compartment.compartment.id]
  display_name   = "${var.compartment_name}-budget"
  description    = "Budget for ${var.compartment_name} compartment"
}