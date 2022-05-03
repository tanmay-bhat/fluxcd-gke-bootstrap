#==========================GKE=========================
variable "project_id" {
  description = "The project ID to host the cluster in"
  default = ""
}
variable "cluster_name" {
  description = "The name for the GKE cluster to create"
  default = "fluxcd-demo"
}
variable "env_name" {
  description = "The environment for the GKE cluster : Dev/Staging/Prod"
  default     = "dev"
}
variable "region" {
  description = "The region to host the cluster in"
  default     = "us-central1"
}

variable "minnode" {
  description = "Mininum number of nodes in node-pool"
  default     = "2"
}

variable "maxnode" {
  description = "Maximum number of nodes in node-pool"
  default     = "3"
}

variable "disksize" {
  description = "Disk Size in GB"
  default     = "25"
}

#==========================Flux & Github==================

variable "github_owner" {
  type        = string
  description = "Github username in which the repository exists"
}

variable "github_token" {
  type        = string
  description = "github token"
}

variable "repository_name" {
  type        = string
  default     = "fluxcd"
  description = "The Github repository name in which FluxCD configs exists"
}

variable "repository_visibility" {
  type        = string
  default     = "public"
  description = "How visible is the github repo, Public/Private"
}

variable "branch" {
  type        = string
  default     = "main"
  description = "The Branch name in which FluxCD configs exists"
}

variable "target_path" {
  type        = string
  default     = "./clusters/staging"
  description = "flux sync target path"
}