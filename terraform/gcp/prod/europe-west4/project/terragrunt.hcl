include {
  path = find_in_parent_folders()
}

locals {
  region      = read_terragrunt_config(find_in_parent_folders("region.hcl")).locals.region
  environment = read_terragrunt_config(find_in_parent_folders("environment.hcl")).locals.environment
}

inputs = {
  project_name    = "firefly"
  project_id      = "firefly-sargeant"
  org_id          = "643364675450"
  billing_account = "01A083-026476-9EBF66"
  region          = local.region
  environment     = local.environment
}