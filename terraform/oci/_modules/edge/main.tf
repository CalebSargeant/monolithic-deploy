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
      # flash.sh - Flash MikroTik CHR image and reboot
      # This script will download a pre-baked CHR image,
      # write it to /dev/sda, and then reboot the machine.

      set +e

      # Log to a file for debugging
      exec > >(tee /var/log/chr-install.log) 2>&1

      echo "Starting CHR installation at $(date)"
      echo "Downloading and flashing CHR image..."
      curl -L "https://github.com/CalebSargeant/mikrotik-chr/releases/download/v7.18.2/chr.img.gz" | gunzip | dd of=/dev/sda bs=1M || :

      echo "Initiating reboot..."
      # Schedule a reboot in 1 minute to allow the script to complete
      shutdown -r +1 "Rebooting to complete MikroTik CHR installation" &

      echo "Flash script completed at $(date)"
    EOF
    )
  }
}
