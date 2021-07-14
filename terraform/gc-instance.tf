
resource "google_compute_address" "static" {
  for_each = var.users

  name = "ipv4-address-${random_id.instance_id.hex}-${each.key}"
}

resource "google_compute_firewall" "allow_http" {
  name    = "ubuntu-${random_id.instance_id.hex}"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8094", "8080"]
  }

  target_tags = ["ubuntu-${random_id.instance_id.hex}"]
}

# A single Google Cloud Engine instance
resource "google_compute_instance" "ubuntu-vm" {
  for_each = var.users

  name         = "${var.hostname}-${random_id.instance_id.hex}-${each.key}"
  machine_type = var.instance_size
  zone         = var.gcloud_zone

  boot_disk {
    initialize_params {
      image = var.gce_image_name # OS version
      size  = var.gce_disk_size  # size of the disk in GB
    }
  }

  network_interface {
    network = "default"

    access_config {
      # Include this section to give the VM an external ip address
      nat_ip = google_compute_address.static[each.key].address
    }
  }

  metadata = {
    sshKeys = "ubuntu:${file(var.ssh_keys["public"])}"
  }

  tags = ["ubuntu-${random_id.instance_id.hex}"]

  connection {
    host        = self.network_interface.0.access_config.0.nat_ip
    type        = "ssh"
    user        = var.gce_username
    private_key = file(var.ssh_keys["private"])
  }

  ## Add easyTravel binary to home dir
  provisioner "file" {
    source      = "${path.module}/files"
    destination = "~/"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo useradd -m -s /bin/bash -p $(openssl passwd -1 ${var.user_password}) dtu.training",
      "sudo usermod -aG sudo dtu.training",
      "sudo sed -i \"s|^PasswordAuthentication no.*|PasswordAuthentication yes|g\" /etc/ssh/sshd_config",
      "sudo systemctl restart ssh",
      "sudo chmod +x ~/files/scripts/lab_setup.sh",
      "sudo VM_PUBLIC_IP=${self.network_interface.0.access_config.0.nat_ip} DT_CLUSTER_URL=${var.dt_cluster_url} DT_CLUSTER=${replace (var.dt_cluster_url, "https://", "")} DT_ENVIRONMENT_ID=${dynatrace_environment.vhot_env[each.key].id} DT_ENVIRONMENT_TOKEN=${dynatrace_environment.vhot_env[each.key].api_token} HAIP=${google_compute_instance.haproxy-vm.network_interface[0].access_config[0].nat_ip} ~/files/scripts/lab_setup.sh",
      "sudo mv ~/files/* /home/dtu.training/",
      "sudo wget -O /home/dtu.training/easyTravel/dynatrace-easytravel-linux-x86_64.jar https://dexya6d9gs5s.cloudfront.net/latest/dynatrace-easytravel-linux-x86_64.jar",
      "( cd /home/dtu.training/easyTravel/ && java -jar /home/dtu.training/easyTravel/dynatrace-easytravel-linux-x86_64.jar -y )",
      "sudo chmod +x /home/dtu.training/scripts/*.sh",
      "sudo chmod +x /home/dtu.training/easyTravel/*.sh",
      "sudo chmod +x /home/dtu.training/*.sh",
      "sudo chown -R dtu.training:dtu.training /home/dtu.training/",
      "sudo -i -u dtu.training /home/dtu.training/scripts/install_packages.sh",
      "rm -rf ~/files"
    ]
  }
}