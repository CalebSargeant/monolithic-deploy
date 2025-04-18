provider "google" {
  project = var.project_id
  region  = var.region
}

# Create a GCP project
resource "google_project" "project" {
  name            = var.project_name
  project_id      = var.project_id
  org_id          = var.org_id
  billing_account = var.billing_account
}

# Enable essential APIs
resource "google_project_service" "apis" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "compute.googleapis.com"
  ])

  project = google_project.project.project_id
  service = each.value
}