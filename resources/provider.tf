terraform {
  backend "gcs" {
    bucket = "sekai67-tfstate" // TODO
    prefix = "sekai67-test"
  }
}

variable "project" {
  default = "sekai67" // TODO
}

locals {
  region = "asia-northeast1"
}

provider "google" {
  project = var.project
  region  = local.region
}
