provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "rancher" {
  name       = "rancher"
  chart      = "rancher"
  repository = "https://releases.rancher.com/server-charts/stable"
  namespace  = "cattle-system"

  set {
    name  = "hostname"
    value = var.hostname
  }

  set {
    name  = "bootstrapPassword"
    value = var.bootstrap_password
  }

  set {
    name  = "ingress.tls.source"
    value = "rancher"
  }
}

resource "kubernetes_namespace" "cattle_system" {
  metadata {
    name = "cattle-system"
  }
}