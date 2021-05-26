/*
   GCP LINUX HOST DEPLOYMENT
*/
terraform {
  required_version = ">= 0.12.6"
}

# Configure the Google Cloud provider
provider "google" {
  # see here how to get this file
  # https://console.cloud.google.com/apis/credentials/serviceaccountkey 
  credentials = file(var.gcloud_cred_file)
  project     = var.gcloud_project
  region      = join("-", slice(split("-", var.gcloud_zone), 0, 2))
}

# Terraform plugin for creating random ids
resource "random_id" "instance_id" {
  byte_length = 8
}

resource "google_compute_address" "static" {
  count        = var.instance_count

  name = "ipv4-address-${random_id.instance_id.hex}-${count.index}"
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
  count        = var.instance_count

  name         = "${var.hostname}-${random_id.instance_id.hex}-${count.index}"
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
      nat_ip = google_compute_address.static[count.index].address
    }
  }

  metadata = {
    sshKeys = "ubuntu:${file(var.ssh_pub_key)}"
  }

  tags = ["ubuntu-${random_id.instance_id.hex}"]

  connection {
    host        = self.network_interface.0.access_config.0.nat_ip
    type        = "ssh"
    user        = var.gce_username
    private_key = file(var.ssh_priv_key)
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
      "sudo sh ~/files/scripts/lab_setup.sh",
      "sudo mv ~/files/* /home/dtu.training/",
      "sudo wget -O /home/dtu.training/easyTravel/dynatrace-easytravel-linux-x86_64.jar https://dexya6d9gs5s.cloudfront.net/latest/dynatrace-easytravel-linux-x86_64.jar",
      "sudo chmod +x /home/dtu.training/scripts/*.sh",
      "sudo chmod +x /home/dtu.training/easyTravel/*.sh",
      "sudo chmod +x /home/dtu.training/*.sh",
      "sudo chown -R dtu.training:dtu.training /home/dtu.training/",
      "rm -rf ~/files"
    ]
  }

}

output "ubuntu-ip" {
  value = [google_compute_instance.ubuntu-vm.*.network_interface.0.access_config.0.nat_ip]
}
