provider "google" {
  project = var.project_id
  region  = var.region
}

# Enable required Google APIs
resource "google_project_service" "required_apis" {
  for_each = toset([
    "compute.googleapis.com",   # VPC, subnets, firewalls, routes
    "container.googleapis.com", # GKE
    "iam.googleapis.com",       # IAM roles, service accounts
    "cloudresourcemanager.googleapis.com",
    "servicenetworking.googleapis.com", # Private services access
    "containerregistry.googleapis.com", # GCR
    "artifactregistry.googleapis.com",  # Artifact Registry
    "monitoring.googleapis.com",        # GKE monitoring
    "logging.googleapis.com",           # GKE logging
  ])

  project = var.project_id
  service = each.key

  disable_on_destroy = false
}


# VPC + Subnest with secondary ranges for pods and services

resource "google_compute_network" "vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false

  depends_on = [google_project_service.required_apis]

}

resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  region        = var.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = var.subnet_cidr

  secondary_ip_range {
    range_name    = "pods-range"
    ip_cidr_range = var.pods_secondary_range
  }

  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = var.services_secondary_range
  }

  depends_on = [google_project_service.required_apis]

}

# GKE Cluster 

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "~> 44.0.0"

  configure_ip_masq   = false
  deletion_protection = false


  name       = var.cluster_name
  project_id = var.project_id
  region     = var.region

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  ip_range_pods     = "pods-range"
  ip_range_services = "services-range"

  remove_default_node_pool = true
  initial_node_count       = 1

  node_pools = [
    {
      name            = "primary-pool"
      machine_type    = "e2-standard-2"
      node_count      = 2
      auto_repair     = true
      auto_upgrade    = true
      disk_type       = "pd-standard"
      disk_size_gb    = 30
      local_ssd_count = 0
    }
  ]


  depends_on = [google_project_service.required_apis]

}