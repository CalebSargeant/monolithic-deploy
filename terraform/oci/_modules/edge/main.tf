# This instance will be a Mikrotik CHR using OCI free tier x86 machine

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
      # Download Mikrotik CHR
      curl -o /tmp/chr-6.49.6.img https://download.mikrotik.com/routeros/6.49.6/chr-6.49.6.img

      # Install required packages
      apt-get update
      apt-get install -y qemu-kvm libvirt-daemon-system

      # Create a directory for CHR
      mkdir -p /opt/chr

      # Move the CHR image to the directory
      mv /tmp/chr-6.49.6.img /opt/chr/

      # Create a systemd service for CHR
      cat > /etc/systemd/system/chr.service << 'EOL'
      [Unit]
      Description=Mikrotik Cloud Hosted Router
      After=network.target

      [Service]
      Type=simple
      ExecStart=/usr/bin/qemu-system-x86_64 -m 256 -hda /opt/chr/chr-6.49.6.img -nographic
      Restart=always

      [Install]
      WantedBy=multi-user.target
      EOL

      # Enable and start the service
      systemctl enable chr.service
      systemctl start chr.service
    EOF
    )
  }
}
