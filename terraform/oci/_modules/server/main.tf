# This instance will be a k3s instance using the ARM64 free tier OCI

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

resource "oci_core_instance" "this" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_ocid
  display_name        = "${var.environment}-k3s-server"
  shape               = var.shape

  shape_config {
    ocpus         = var.ocpus
    memory_in_gbs = var.memory_in_gbs
  }

  create_vnic_details {
    subnet_id        = var.subnet_id
    assign_public_ip = true
    nsg_ids          = [var.network_security_group_id]
  }

  source_details {
    source_type = "image"
    source_id   = var.image_ocid
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key_path)
    user_data = base64encode(<<-EOF
      #!/bin/bash
      # Install k3s
      curl -sfL https://get.k3s.io | sh -
      # Allow current user to access k3s config
      mkdir -p /home/ubuntu/.kube
      cp /etc/rancher/k3s/k3s.yaml /home/ubuntu/.kube/config
      chown -R ubuntu:ubuntu /home/ubuntu/.kube
      # Set correct permissions
      chmod 600 /home/ubuntu/.kube/config
    EOF
    )
  }
}
