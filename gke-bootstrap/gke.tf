#GKE cluster
module "gke" {
  source                 = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  project_id             = var.project_id
  name                   = "${var.cluster_name}-${var.env_name}"
  regional               = false
  region                 = var.region
  zones                  = ["us-central1-a"]
  network                = module.vpc.network_name
  subnetwork             = module.vpc.subnets_names[0]
  ip_range_pods          = "${var.cluster_name}-${var.env_name}-ip-range-pods"	
  ip_range_services      = "${var.cluster_name}-${var.env_name}-ip-range-services"	
  enable_private_endpoint    = false
  enable_private_nodes       = true 
  master_ipv4_cidr_block     = "10.0.0.0/28" 
  depends_on             = [module.vpc.network_name]
  remove_default_node_pool =  true
  logging_service        = "none"
  monitoring_service     = "none"
  node_pools = [
    {
      name                      = "${var.cluster_name}-${var.env_name}-primary-nodepool"
      machine_type              = "e2-medium"
      node_locations            = "us-central1-a"
      min_count                 = var.minnode
      max_count                 = var.maxnode
      disk_size_gb              = var.disksize
      preemptible               = false
    },
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