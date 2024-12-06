terraform {
  source = "../modules/rancher"
}

inputs = {
  hostname           = "rancher.sargeant.co"
  bootstrap_password = "securepassword"
}