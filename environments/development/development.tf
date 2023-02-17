data "google_container_registry_image" "api" {
  name = "api"
}

resource "google_container_registry" "development_registry" {
  project  = var.project_id
  location = "US"
}


data "google_client_config" "default" {}

resource "google_compute_subnetwork" "custom" {
  name          = "development-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.custom.id
  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "192.168.1.0/24"
  }

  secondary_ip_range {
    range_name    = "pod-ranges"
    ip_cidr_range = "192.168.64.0/22"
  }
}

resource "google_compute_network" "custom" {
  name                    = "development-vpc"
  auto_create_subnetworks = false
}



provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

locals {
  cluster_type = "regional-private"
}

module "gke" {
  source                    = "../../modules/google-gke-private/"
  project_id                = var.project_id
  name                      = "${local.cluster_type}-${var.cluster_name_suffix}"
  regional                  = true
  region                    = var.region
  network                   = google_compute_network.custom.id
  subnetwork                = google_compute_subnetwork.custom.id
  ip_range_pods             = google_compute_subnetwork.custom.secondary_ip_range[0].ip_cidr_range
  ip_range_services         = google_compute_subnetwork.custom.secondary_ip_range[1].ip_cidr_range
  create_service_account    = true
  enable_private_endpoint   = true
  enable_private_nodes      = true
  master_ipv4_cidr_block    = "172.16.0.0/28"
  default_max_pods_per_node = 20
  remove_default_node_pool  = true

  node_pools = [
    {
      name              = "pool-01"
      min_count         = 4
      max_count         = 10
      local_ssd_count   = 0
      disk_size_gb      = 100
      disk_type         = "pd-standard"
      auto_repair       = true
      auto_upgrade      = true
      service_account   = "cicd-github-actions@latam-challenge.iam.gserviceaccount.com"
      preemptible       = false
      max_pods_per_node = 12
    },
  ]

  master_authorized_networks = [
    {
      cidr_block   = google_compute_subnetwork.custom.ip_cidr_range
      display_name = "VPC"
    },
  ]
  depends_on = [
    google_compute_subnetwork.custom
  ]
}