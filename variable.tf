variable "project_id" {
  description = "GCP PROJECT ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "cluster_name" {
  description = "GKE cluster name"
  type        = string
}

variable "network_name" {
  description = "VPC name"
  type        = string
}

variable "subnet_name" {
  description = "Subnet name"
  type        = string
}

variable "subnet_cidr" {
  description = "Primary subnet CIDR"
}

variable "pods_secondary_range" {
  description = "Secondary range for Pods"
}

variable "services_secondary_range" {
  description = "Secondary range for Services"
}