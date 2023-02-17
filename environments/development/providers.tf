provider "google" {
  project = "latam-challenge"
  region  = "us-central1"
}


terraform {
  backend "gcs" {
    bucket = "challenge-tf"
    prefix    = "tf/state/development"
  }
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
  required_version = ">= 0.13"
}