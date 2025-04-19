# This instance will be a Mikrotik CHR using OCI free tier x86 machine
# The instance will directly flash the CHR image to disk during provisioning

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

resource "oci_core_instance" "this" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_ocid
  display_name        = "${var.environment}-mikrotik-chr"
  shape               = var.shape

  create_vnic_details {
    subnet_id              = var.subnet_id
    assign_public_ip       = true
    nsg_ids                = [var.network_security_group_id]
    skip_source_dest_check = true
  }

  source_details {
    source_type = "image"
    source_id   = var.image_ocid
  }
}
