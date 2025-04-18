variable "compartment_name" {
  description = "Name of the OCI compartment"
  type        = string
}

variable "compartment_description" {
  description = "Description of the OCI compartment"
  type        = string
  default     = "Managed by Terraform"
}

variable "tenancy_ocid" {
  description = "OCID of the OCI tenancy"
  type        = string
}

variable "region" {
  description = "Region for resources"
  type        = string
}

variable "environment" {
  description = "Environment (e.g., prod, dev, test)"
  type        = string
}

variable "budget_amount" {
  description = "Budget amount for the compartment"
  type        = number
  default     = 1000
}