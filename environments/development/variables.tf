variable "project_id" {
  type    = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "cluster_name_suffix" {
  description = "A suffix to append to the default cluster name"
  default     = ""
}
