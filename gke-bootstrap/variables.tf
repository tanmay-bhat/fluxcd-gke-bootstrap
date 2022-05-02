#==========================GKE=========================
variable "project_id" {
  description = "The project ID to host the cluster in"
}
variable "cluster_name" {
  description = "The name for the GKE cluster"
}
variable "env_name" {
  description = "The environment for the GKE cluster"
  default     = "dev"
}
variable "region" {
  description = "The region to host the cluster in"
  default     = "us-central1"
}

#==========================Flux & Github==================

variable "github_owner" {
  type        = string
  description = "github username"
  default = "tanmay-bhat"
}

variable "github_token" {
  type        = string
  description = "github token"
}

variable "repository_name" {
  type        = string
  default     = "fluxcd"
  description = "github repository name"
}

variable "repository_visibility" {
  type        = string
  default     = "public"
  description = "How visible is the github repo"
}

variable "branch" {
  type        = string
  default     = "main"
  description = "branch name"
}

variable "target_path" {
  type        = string
  default     = "./clusters/staging"
  description = "flux sync target path"
}