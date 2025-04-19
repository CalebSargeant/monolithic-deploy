resource "google_compute_instance" "free_vm" {
  name         = "k3s-vm"
  machine_type = "e2-micro"
  zone         = var.zone

  tags = ["k3s", "monitoring"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 30
      type  = "pd-standard"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    set -e

    echo "[startup] Updating packages..."
    apt-get update

    echo "[startup] Installing dependencies..."
    apt-get install -y curl

    echo "[startup] Creating 7GB swapfile..."
    fallocate -l 7G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile none swap sw 0 0' >> /etc/fstab

    echo "[startup] Tuning sysctl for swap usage..."
    echo 'vm.swappiness=10' >> /etc/sysctl.conf
    echo 'vm.vfs_cache_pressure=50' >> /etc/sysctl.conf
    sysctl -p

    echo "[startup] Installing K3s..."
    curl -sfL https://get.k3s.io | sh -

    echo "[startup] Startup script complete."
  EOT

  labels = {
    env = "k3s-lab"
  }
}