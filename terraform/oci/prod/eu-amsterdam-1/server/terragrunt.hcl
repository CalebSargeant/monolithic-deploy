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

dependency "edge" {
  config_path = "../edge"
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
  image_ocid              = "ocid1.image.oc1.eu-amsterdam-1.aaaaaaaahc3kbflujx4g536l4yuzzy7udc6ltwlbt7iqbkt33i6zx62yy7va"
  # Route all traffic through the edge CHR
  edge_private_ip         = dependency.edge.outputs.private_ip
  edge_instance_id        = dependency.edge.outputs.instance_id
  subnet_cidr             = "172.17.1.0/24"
    vcn_id = dependency.network.outputs.vcn_id

}
