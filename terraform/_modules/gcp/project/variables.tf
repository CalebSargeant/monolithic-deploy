variable "project_name" {
  description = "Name of the GCP project"
  type        = string
    default     = local.project_name
}

variable "project_id" {
  description = "Unique ID of the GCP project"
  type        = string
    default     = local.project_id
}

variable "org_id" {
  description = "GCP organisation ID"
  type        = string
  default = local.org_id
}

variable "billing_account" {
  description = "Billing account to link to the project"
  type        = string
  default = local.billing_account
}

variable "region" {
  description = "Region for resources"
  type        = string
  default     = local.environment
}