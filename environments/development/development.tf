data "google_container_registry_image" "api" {
  name = "api"
}

resource "google_project_service" "run_api" {
  service = "run.googleapis.com"

  disable_on_destroy = true
}

module "development_cloudrun" {
  source  = "../../modules/google-cloud-run"
  service_name           = "jupyter-api-development"
  project_id             = var.project_id
  location               = var.location
  image                  = data.google_container_registry_image.api.image_url
}


resource "google_container_registry" "development_registry" {
  project  = var.project_id
  location = var.location
}