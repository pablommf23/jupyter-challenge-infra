provider "google" {
  project = "latam-challenge"
  region  = "us-central1"
}


terraform {
  backend "gcs" {
    bucket = "challenge-tf"
    prefix    = "tf/state/development"
  }
}