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
      subnet_private_access = true
    },
  ]
  secondary_ranges = {
    "${var.cluster_name}-${var.env_name}-subnet" = [
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


#Cloud NAT
resource "google_compute_address" "nat" {
  name    = format("%s-%s-nat-ip", var.cluster_name,var.env_name)
  project = var.project_id
  region  = var.region
}

resource "google_compute_router" "flux-dev-router" {
  name    = format("%s-%s-cloud-router", var.cluster_name,var.env_name)
  project = var.project_id
  region  = var.region
  network = module.vpc.network_name
}


module "cloud-nat" {
  source                             = "terraform-google-modules/cloud-nat/google"
  project_id                         = var.project_id
  region                             = var.region
  router                             = google_compute_router.flux-dev-router.name
  name                               = format("%s-cloud-nat", var.cluster_name)
  nat_ips                            = ["${google_compute_address.nat.self_link}"]
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetworks = [
    {
    name  =  module.vpc.subnets_names[0]
    source_ip_ranges_to_nat = ["PRIMARY_IP_RANGE", "LIST_OF_SECONDARY_IP_RANGES"]
    secondary_ip_range_names = [module.vpc.subnets_secondary_ranges[0].0.range_name, 
    module.vpc.subnets_secondary_ranges[0].1.range_name
      ]
    }   
  ]             
}



