remote_state {
  backend = "s3"
  config = {
    bucket         = "my-terragrunt-bucket"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-west-2"
  }
}

terraform {
  extra_arguments "common_vars" {
    commands = ["plan", "apply", "destroy"]
    arguments = [
      "-var-file=${get_terragrunt_dir()}/common.tfvars"
    ]
  }
}