output "cluster_name" {
  value = module.gke.name
}

output "region" {
  value = var.region
}

output "endpoint" {
  value     = module.gke.endpoint
  sensitive = true
}