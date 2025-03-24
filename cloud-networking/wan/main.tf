terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

// Create the VPC

resource "google_compute_network" "tf-mod3-lab1-network1" {
  name = "tf-mod3-lab1-network1"
  auto_create_subnetworks = "false"
}


resource "google_compute_network" "tf-mod3-lab1-network2" {
  name = "tf-mod3-lab1-network2"
  auto_create_subnetworks = "false"
}

// Create the subnet
// https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork

resource "google_compute_subnetwork" "tf-mod3-lab1-subnet1" {
  name          = "tf-mod3-lab1-subnet1"
  ip_cidr_range = "172.16.0.0/24"
  region        = "us-central1"
  network       = google_compute_network.tf-mod3-lab1-network1.id
}

resource "google_compute_subnetwork" "tf-mod3-lab1-subnet2" {
  name          = "tf-mod3-lab1-subnet2"
  ip_cidr_range = "172.16.1.0/24"
  region        = "us-east1"
  network       = google_compute_network.tf-mod3-lab1-network2.id
}


// Create Firewall rule - allow icmp, tcp:22 (ssh), and tcp:1234 (custom)
//https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall

resource "google_compute_firewall" "tf-mod3-lab1-fwrule1" {
  project = "module3-454719"
  name        = "tf-mod3-lab1-fwrule1"
  network     = "tf-mod3-lab1-network1"

  depends_on = [google_compute_network.tf-mod3-lab1-network1]

  allow {
    protocol  = "tcp"
    ports     = ["22", "1234"]
  }

  allow {
    protocol = "icmp"
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "tf-mod3-lab1-fwrule2" {
  project = "module3-454719"
  name        = "tf-mod3-lab1-fwrule2"
  network     = "tf-mod3-lab1-network2"

  depends_on = [google_compute_network.tf-mod3-lab1-network2]

  allow {
    protocol  = "tcp"
    ports     = ["22", "1234"]
  }

  allow {
    protocol = "icmp"
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "vxlan1" {
  name    = "allow-vxlan1"
  network = "tf-mod3-lab1-network1" 
  allow {
    protocol = "udp"
    ports    = ["50000"]
  }

  direction = "INGRESS"
  source_ranges = ["0.0.0.0/0"]

  priority = 1000
}

resource "google_compute_firewall" "vxlan2" {
  name    = "allow-vxlan2"
  network = "tf-mod3-lab1-network2"

  allow {
    protocol = "udp"
    ports    = ["50000"]
  }

  direction = "INGRESS"
  source_ranges = ["0.0.0.0/0"]

  priority = 1000
}


// Create a VM, and put it inside of subnet1
// https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance

resource "google_compute_instance" "tf-mod3-lab1-vm1" {
  name = "tf-mod3-lab1-vm1"
  machine_type = "e2-micro"
  zone = "us-central1-a"  
  depends_on = [google_compute_network.tf-mod3-lab1-network1, google_compute_subnetwork.tf-mod3-lab1-subnet1]
  network_interface {
    network = "tf-mod3-lab1-network1"
    subnetwork = "tf-mod3-lab1-subnet1"
  }

  boot_disk {
    initialize_params {
      image = "debian-12-bookworm-v20240312"
    }
  } 
  metadata = {
    startup-script = "sudo apt update; sudo apt -y install netcat-traditional ncat;"
  }

}

resource "google_compute_instance" "tf-mod3-lab1-vm2" {
  name = "tf-mod3-lab1-vm2"
  machine_type = "e2-micro"
  zone = "us-east1-b"  
  depends_on = [google_compute_network.tf-mod3-lab1-network2, google_compute_subnetwork.tf-mod3-lab1-subnet2]
  network_interface {
    network = "tf-mod3-lab1-network2"
    subnetwork = "tf-mod3-lab1-subnet2"
  }

  boot_disk {
    initialize_params {
      image = "debian-12-bookworm-v20240312"
    }
  } 
  metadata = {
    startup-script = "sudo apt update; sudo apt -y install netcat-traditional ncat;"
  }

}

resource "google_compute_network_peering" "tf-mod3-lab1-peering1" {
  name         = "tf-mod3-lab1-peering1"
  network      = google_compute_network.tf-mod3-lab1-network1.self_link
  peer_network = google_compute_network.tf-mod3-lab1-network2.self_link
}

resource "google_compute_network_peering" "tf-mod3-lab1-peering2" {
  name         = "tf-mod3-lab1-peering2"
  network      = google_compute_network.tf-mod3-lab1-network2.self_link
  peer_network = google_compute_network.tf-mod3-lab1-network1.self_link
}

resource "google_compute_router" "cloud-router" {
  name    = "cloud-router"
  region  = google_compute_subnetwork.tf-mod3-lab1-subnet2.region
  network = google_compute_network.tf-mod3-lab1-network2.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "cloud-router-nat" {
  name                               = "cloud-router-nat"
  router                             = google_compute_router.cloud-router.name
  region                             = google_compute_router.cloud-router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

//terraform show -json | jq

// If you see something like this:
// │ Error: Error creating instance: googleapi: Error 400: Invalid value for field 'resource.networkInterfaces[0].subnetwork': 'projects/orbital-linker-398719/regions/us-central1/subnetworks/tf-mod2-demo1-subnet1'. The referenced subnetwork resource cannot be found., invalid
// There's a dependency that terraform didn't resolve, so it's trying to create X which depends on Y existing.
// To solve, use depends_on
