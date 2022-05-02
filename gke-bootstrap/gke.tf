#GKE cluster
module "gke" {
  source                 = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  project_id             = var.project_id
  name                   = "${var.cluster_name}-${var.env_name}"
  regional               = true
  region                 = var.region
  network                = module.vpc.network_name
  subnetwork             = module.vpc.subnets_names[0]
  ip_range_pods          = var.ip_range_pods_name
  ip_range_services      = var.ip_range_services_name
  enable_private_endpoint    = true
  enable_private_nodes       = true 
  depends_on             = [module.vpc]
  node_pools = [
    {
      name                      = "node-pool"
      machine_type              = "e2-medium"
      node_locations            = "us-central1-a"
      min_count                 = 1
      max_count                 = 2
      disk_size_gb              = 30
    }
  ]
}

#GKE Auth
module "gke_auth" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  depends_on   = [module.gke]
  project_id   = var.project_id
  location     = module.gke.location
  cluster_name = module.gke.name
}
resource "local_file" "kubeconfig" {
  content  = module.gke_auth.kubeconfig_raw
  filename = "kubeconfig-${var.env_name}"
}


#VPC & Subnet for the GKE Cluster
module "vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 5.0.0"
  project_id   = var.project_id
  network_name = "${var.network}-${var.env_name}"
  subnets = [
    {
      subnet_name   = "${var.subnetwork}-${var.env_name}"
      subnet_ip     = "10.10.0.0/16"
      subnet_region = var.region
    },
  ]
  secondary_ranges = {
    "${var.subnetwork}-${var.env_name}" = [
      {
        range_name    = var.ip_range_pods_name
        ip_cidr_range = "10.20.0.0/16"
      },
      {
        range_name    = var.ip_range_services_name
        ip_cidr_range = "10.30.0.0/16"
      },
    ]
  }
}

