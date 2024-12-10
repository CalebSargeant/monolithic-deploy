# Inherit settings from the main Terragrunt configuration
include {
  path = find_in_parent_folders()
}

# Environment-specific inputs
inputs = {
  zone_id = "6e26afa31c37dee1dc82ad2f214f9b3c"
  records = {
    # "vpn" = {
    #   name    = "vpn.sargeant.co"
    #   type    = "CNAME"
    #   value   = "hgg09z62fwg.sn.mynetname.net"
    #   ttl     = 1
    #   proxied = false
    # }
    # "protonvpn" = {
    #   name    = "protonvpn.sargeant.co"
    #   type    = "A"
    #   value   = "185.107.56.251"
    #   ttl     = 1
    #   proxied = false
    # }
    "test" = {
      name    = "test.sargeant.co"
      type    = "CNAME"
      value   = "vpn.sargeant.co"
      ttl     = 1
      proxied = true
    }
    "photos" = {
      name    = "photos.sargeant.co"
      type    = "CNAME"
      value   = "vpn.sargeant.co"
      ttl     = 1
      proxied = true
    }
  }
}