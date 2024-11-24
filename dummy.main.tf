provider "google" {
  credentials = file("C:/path/to/dummy-credentials.json")
  project     = "dummy-project-id"
  region      = "dummy-region"
}

# Generate an SSH key pair
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Save the public key to a local file
resource "local_file" "public_key" {
  content  = "dummy-public-key-content"
  filename = "dummy-public-key.pub"
}

# Save the private key to a local file
resource "local_file" "private_key" {
  content  = "dummy-private-key-content"
  filename = "dummy-private-key"
}

# Create a custom VPC network
resource "google_compute_network" "custom_network" {
  name                    = "dummy-vpc-network"
  auto_create_subnetworks = false
}

# Create a custom subnet within the VPC
resource "google_compute_subnetwork" "custom_subnet" {
  name          = "dummy-subnet"
  ip_cidr_range = "192.168.0.0/16"
  region        = "dummy-region"
  network       = "dummy-vpc-network-id"
}

# Create a firewall rule to allow SSH, ICMP, and HTTP traffic
resource "google_compute_firewall" "allow_ssh_http_icmp" {
  name    = "dummy-firewall-rule"
  network = "dummy-vpc-network-name"

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["1.1.1.1/32", "2.2.2.2/32", "4.4.4.4/32"]
}

# Create the Google Compute Instance
resource "google_compute_instance" "vm_instance" {
  name         = "dummy-vm-instance"
  machine_type = "e2-micro"
  zone         = "dummy-zone"

  # Boot disk configuration
  boot_disk {
    initialize_params {
      image = "dummy-image"
    }
  }

  # Use the custom VPC network and subnet
  network_interface {
    network    = "dummy-vpc-network-id"
    subnetwork = "dummy-subnet-id"
    access_config {}
  }

  # Metadata for SSH
  metadata = {
    ssh-keys = "dummy-user:dummy-public-key-content"
  }

  # Provisioner to create a .txt file
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "dummy-user"
      private_key = "dummy-private-key-content"
      host        = "dummy-vm-public-ip"
    }

    inline = [
      "echo 'Hello, Dummy Terraform!' > /tmp/hello.txt",
      "cat /tmp/hello.txt"
    ]
  }
}

# Outputs
output "vm_public_ip" {
  value = "dummy-vm-public-ip"
}

output "private_key" {
  value     = "dummy-private-key-content"
  sensitive = true
}

output "public_key" {
  value = "dummy-public-key-content"
}
