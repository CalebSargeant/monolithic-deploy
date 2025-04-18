include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/terraform/oci/_modules/server"
}

locals {
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
}

dependency "network" {
  config_path = "../network"
}

inputs = {
  tenancy_ocid            = get_env("OCI_TENANCY_OCID", "")
  compartment_ocid        = get_env("OCI_COMPARTMENT_OCID", "")
  region                  = local.region_vars.locals.region
  environment             = local.environment_vars.locals.environment
  shape                   = "VM.Standard.A1.Flex"
  ocpus                   = 4
  memory_in_gbs           = 24
  subnet_id               = dependency.network.outputs.subnet_id
  network_security_group_id = dependency.network.outputs.network_security_group_id
  ssh_public_key_path     = "${get_repo_root()}/ansible/keys/id_rsa.pub"
  # Oracle Linux 8 for ARM
  image_ocid              = "ocid1.image.oc1.eu-amsterdam-1.aaaaaaaafkbieqzlgvjlnvdkfzoyy6at5n3xk2nu5wkmu7otjz6wxfn6eqnq"
}
