data "google_container_registry_image" "api" {
  name = "api"
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
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
  image                  = "gcr.io/cloudrun/hello"
  depends_on = [
    google_container_registry.development_registry
  ]
}


resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = var.location
  project     = var.project_id
  service     = module.development_cloudrun.service_name

  policy_data = data.google_iam_policy.noauth.policy_data
}


resource "google_container_registry" "development_registry" {
  project  = var.project_id
  location = "US"
}