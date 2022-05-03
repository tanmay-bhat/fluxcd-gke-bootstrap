terraform {
  required_version = ">= 0.13"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.2"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.10.0"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "0.13.5"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }  
    google = {
      source  = "hashicorp/google" 
      version = "4.19.0"
    }      
  }
}