include {
  path = find_in_parent_folders()
}

locals {
  region      = read_terragrunt_config(find_in_parent_folders("region.hcl")).locals.region
  environment = read_terragrunt_config(find_in_parent_folders("environment.hcl")).locals.environment
}

inputs = {
  project_name    = "Main"
  project_id      = "magmamoose"
  org_id          = "643364675450"
  billing_account = "01A083-026476-9EBF66"
  region          = local.region
  environment     = local.environment
}