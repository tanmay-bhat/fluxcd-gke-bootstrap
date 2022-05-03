## Boostrap GKE cluster with Flux-CD via Terraform

Running terraform will,

1. Create GKE private cluster
2. Install & configure Flux-CD
3. Run the configured podinfo application and expose it via Ingress

### 1. Network.tf : 

- This terraform file creates below resources : 
  - VPC
  - Subnet
  - Cloud router
  - Cloud NAT
  - Static IP adress for NAT

### Note : We would need Cloud NAT because we are creating Private GKE cluster.

### 2. gke.tf 
- This terraform file creates below resources : 
  - GKE cluster
  - GKE node pool
  - kubeconfig file of above created cluster

### Note :  In-order to pull images from public image registry, we would need Cloud NAT as private cluster cant communicate to oputside woudl as they dont have public IP adress.

### 3. fluxcd.tf
- This terraform file performes below actions :
  - Generate kubernetes manifest file for flux-cd install
  - Apply those manifests into flux-system namespace
  - Pull the flux-cd configurations from Github Repository
  - Boostrap the flux-cd with demo tomcat application.
