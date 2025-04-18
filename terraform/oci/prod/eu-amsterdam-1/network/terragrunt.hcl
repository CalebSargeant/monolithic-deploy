include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_repo_root()}/terraform/oci/_modules/network"
}

locals {
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
}

inputs = {
  tenancy_ocid       = get_env("OCI_TENANCY_OCID", "")
  user_ocid          = get_env("OCI_USER_OCID", "")
  fingerprint        = get_env("OCI_FINGERPRINT", "")
  private_key_path   = get_env("OCI_PRIVATE_KEY_PATH", "")
  region             = local.region_vars.locals.region
  compartment_ocid   = get_env("OCI_COMPARTMENT_OCID", "")
  environment        = local.environment_vars.locals.environment
  network_cidr       = "172.16.1.0/16"
  subnet_cidr        = "172.16.1.0/24"
  ssh_public_key_path = "${get_repo_root()}/ansible/keys/id_rsa.pub"
}