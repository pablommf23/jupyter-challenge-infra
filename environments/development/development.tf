module "development_cloudrun" {
  source  = "../../modules/google-cloud-run"
  service_name           = "jupyter-api-development"
  project_id             = "latam-challenge"
  location               = "us-central1"
  image                  = "gcr.io/cloudrun/hello"
}
