output "ubuntu-ip" {
  value = {
    for instance in google_compute_instance.ubuntu-vm:
    instance.id => "${instance.network_interface[0].access_config[0].nat_ip}"
  }
}

output "haproxy-ip" {
  value = google_compute_instance.haproxy-vm.network_interface[0].access_config[0].nat_ip
}
