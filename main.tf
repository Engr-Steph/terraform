provider "google" {
  credentials = file("C:/Users/user/Downloads/terraform-key.json")
  project     = "host-project-419903" # Replace with your GCP project ID
  region      = "us-central1"
}

# Generate an SSH key pair
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Save the public key to a local file
resource "local_file" "public_key" {
  content  = tls_private_key.ssh_key.public_key_openssh
  filename = "id_rsa.pub"
}

# Save the private key to a local file
resource "local_file" "private_key" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "id_rsa"
}

# Create a custom VPC network
resource "google_compute_network" "custom_network" {
  name                    = "custom-vpc-network"
  auto_create_subnetworks = false # Disable auto-creation of subnets
}

# Create a custom subnet within the VPC
resource "google_compute_subnetwork" "custom_subnet" {
  name          = "custom-subnet"
  ip_cidr_range = "10.0.0.0/16" # Adjust the IP range as needed
  region        = "us-central1"
  network       = google_compute_network.custom_network.id
}

# Create a firewall rule to allow SSH, ICMP, and HTTP traffic
resource "google_compute_firewall" "allow_ssh_http_icmp" {
  name    = "allow-ssh-http-icmp"
  network = google_compute_network.custom_network.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80"] # SSH (22), HTTP (80)
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"] # Allow from any IP
}

# Create the Google Compute Instance
resource "google_compute_instance" "vm_instance" {
  name         = "example-vm"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  # Boot disk configuration
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts" # Ubuntu 22.04 LTS
    }
  }

  # Use the custom VPC network and subnet
  network_interface {
    network    = google_compute_network.custom_network.id
    subnetwork = google_compute_subnetwork.custom_subnet.id
    access_config {} # This enables external/public IP
  }

  # Metadata for SSH
  metadata = {
    ssh-keys = "digitalWitch:${tls_private_key.ssh_key.public_key_openssh}"
  }

  # Provisioner to create a .txt file
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "digitalWitch"
      private_key = tls_private_key.ssh_key.private_key_pem
      host        = self.network_interface[0].access_config[0].nat_ip
    }

    inline = [
      "echo 'Hello, Terraform!' > /tmp/hello.txt",
      "cat /tmp/hello.txt"
    ]
  }
}

# Outputs
output "vm_public_ip" {
  value = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}

output "private_key" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}

output "public_key" {
  value = tls_private_key.ssh_key.public_key_openssh
}
