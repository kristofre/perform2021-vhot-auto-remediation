output "haproxy-ip" {
  value = google_compute_instance.haproxy-vm.network_interface[0].access_config[0].nat_ip
}

output "users" {
  value = {
    for index, user in var.users:
    user.email => google_compute_instance.ubuntu-vm[index].network_interface[0].access_config[0].nat_ip
  }
}

output "ubuntu_ip" {
  value = "connect using: ssh -i ${path.module}/key ${var.gce_username}@ip_address"
}