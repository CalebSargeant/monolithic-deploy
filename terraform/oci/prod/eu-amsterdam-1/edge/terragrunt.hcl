include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/terraform/oci/_modules/edge"
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
  shape                   = "VM.Standard.E2.1.Micro"
  subnet_id               = dependency.network.outputs.subnet_id
  network_security_group_id = dependency.network.outputs.network_security_group_id
  ssh_public_key_path     = "${get_repo_root()}/ansible/keys/id_rsa.pub"
  # Oracle Linux 8 for x86
  image_ocid              = "ocid1.image.oc1.eu-amsterdam-1.aaaaaaaawxrjyvekcjkpi3zo6x3fphepbrjrbvr2dkcdxwir7xdwpv2yfvqa"
}
