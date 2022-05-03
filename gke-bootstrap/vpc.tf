#VPC & Subnet for the GKE Cluster
module "vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 5.0.0"
  project_id   = var.project_id
  network_name = "${var.cluster_name}-${var.env_name}-vpc"
  subnets = [
    {
      subnet_name   = "${var.cluster_name}-${var.env_name}-subnet"
      subnet_ip     = "10.10.0.0/16"
      subnet_region = var.region
    },
  ]
  secondary_ranges = {
    "${var.env_name}-subnet" = [
      {
        range_name    = "${var.cluster_name}-${var.env_name}-ip-range-pods" 
        ip_cidr_range = "10.20.0.0/16"
      },
      {
        range_name    = "${var.cluster_name}-${var.env_name}-ip-range-services" 
        ip_cidr_range = "10.30.0.0/16"
      },
    ]
  }
}