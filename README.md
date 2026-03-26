# GKE Jenkins Monitoring Setup

This repository contains Terraform infrastructure-as-code to deploy a Google Kubernetes Engine (GKE) cluster with Jenkins and monitoring capabilities.

## Prerequisites

- **Terraform** >= 1.5.0
- **Google Cloud SDK** (`gcloud` CLI)
- **kubectl** for Kubernetes interactions
- Active Google Cloud project with billing enabled

## Setup Instructions

### 1. Authenticate with Google Cloud

```bash
gcloud auth application-default login
```

This command opens a browser to authenticate and stores credentials for Terraform use.

### 2. Set Variables

Create a `terraform.tfvars` file in this directory:

```hcl
project_id                = "your-gcp-project-id"
region                    = "us-central1"
cluster_name              = "gke-jenkins-cluster"
network_name              = "gke-vpc"
subnet_name               = "gke-subnet"
subnet_cidr               = "10.0.0.0/24"
pods_secondary_range      = "10.1.0.0/16"
services_secondary_range  = "10.2.0.0/16"
```

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Review & Apply

```bash
terraform plan
terraform apply
```

## Project Structure

```
gke-jenkins-monitoring/
├── main.tf              # GKE cluster, VPC, and subnets
├── version.tf           # Terraform and provider versions
├── variables.tf         # Input variable definitions
├── outputs.tf           # Output values
├── .gitignore           # Git ignore rules
└── README.md            # This file
```

## Architecture

- **VPC Network**: Custom VPC with secondary IP ranges for pods and services
- **GKE Cluster**: 
  - 1 control plane (managed by Google)
  - Primary node pool with 2 `e2-standard-2` nodes
  - 30GB disk storage per node
- **APIs Enabled**: Compute, Container, IAM, Cloud Resource Manager, Service Networking, GCR, Artifact Registry, Monitoring, Logging

## Resource Details

### Network
- VPC: `gke-vpc`
- Subnet: `gke-subnet` (10.0.0.0/24)
- Pod CIDR: 10.1.0.0/16
- Service CIDR: 10.2.0.0/16

### GKE Cluster
- Machine Type: `e2-standard-2`
- Node Count: 2
- Auto-repair: Enabled
- Auto-upgrade: Enabled
- IP Masquerading: Disabled

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

## Troubleshooting

### "No credentials loaded" Error
Run: `gcloud auth application-default login`

### Deprecated Resource Warning
The module uses newer Kubernetes provider versions. Update if needed:
```bash
terraform init -upgrade
```

### Provider Version Conflicts
Check `version.tf` for compatible versions:
- Google Provider: `~> 7.0`
- Kubernetes Provider: `~> 2.30`

## Security Notes

⚠️ **Never commit the following to Git:**
- `terraform.tfvars` (contains sensitive values)
- `*.tfstate` files
- Credential files (`.json` keys)
- `.kube/` directories

See `.gitignore` for complete exclusion list.

## Next Steps

1. Configure kubectl to access the cluster:
   ```bash
   gcloud container clusters get-credentials <cluster-name> --region <region>
   ```

2. Deploy Jenkins and monitoring stack using Helm charts

3. Configure firewall rules for Jenkins access

## Support

For issues with:
- **Terraform**: Check [Terraform GCP Provider Docs](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- **GKE**: See [Google Kubernetes Engine Docs](https://cloud.google.com/kubernetes-engine/docs)
- **Jenkins**: Visit [Jenkins Kubernetes Integration](https://www.jenkins.io/doc/book/installing/kubernetes/)