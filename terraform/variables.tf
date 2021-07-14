variable "gcloud_project" {
  description = "Name of GCloud project to spin up the bastion host"
  default     = "detroit-acl-v2"
}

variable "gcloud_zone" {
  description = "Zone of the GCloud project"
  default     = "us-central1-a"
}

variable "gcloud_cred_file" {
  description = "Path to GCloud credential file"
}

variable "dt_cluster_url" {
  description = "Dynatrace cluster URL"
}

variable "dt_cluster_api_token" {
  description = "Dynatrace cluster API token"
}

variable "instance_size" {
  description = "Size of the bastion host"
  default     = "n1-standard-2"
}

variable "gce_image_name" {
  description = "The image to use for this vm"
  default     = "ubuntu-minimal-2004-focal-v20210707"
}

variable "user_password" {
  description = "Password for linux user"
  default     = "dynatrace"
}

variable "hostname" {
  description = "Name of the gke clusters followed by count.index + 1"
  default     = "ubuntu-vm"
}

variable "gce_username" {
  description = "The user name to use for basic auth for the cluster."
  default     = "ubuntu"
}

variable "gce_disk_size" {
  description = "Size of the disk attached to each node, specified in GB. The smallest allowed disk size is 10GB"
  default     = 40
}

variable "name_prefix" {
  description = "Name Prefix"
}

variable "users" {
  description = "Map of lab participants"
  type = map(object({
    email = string
    firstName = string
    lastName = string
  }))
  default = {
    0 = {
      email = "john.smith@example.com"
      firstName = "John"
      lastName = "Smith"
    },
  }
}

variable "ssh_keys" {
  description = "Paths to public and private SSH keys for ace-box user"
  default = {
    private = "./key"
    public  = "./key.pub"
  }
}